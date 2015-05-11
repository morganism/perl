package Ascertain::UM::Readers::AMA;
use strict;

use Ascertain::UM::Readers::Convert::EBCDIC;
use Data::Dumper;
use English qw( -no_match_vars );
use POSIX qw( strftime );

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::Readers::Reader);

use constant FALSE => undef;
use constant TRUE => 1;
use constant BYTES_BLOCK_HEADER => "BYTES_BLOCK_HEADER";
use constant BYTES_RECORD_HEADER => "BYTES_RECORD_HEADER";
use constant BYTES_CDR => "BYTES_CDR";
use constant BYTES_CONSUMED => "BYTES_CONSUMED";


=top
All readers do this

@return A hash of field_name => value
=cut
sub getRecord
{
	my $self = shift;

	$self->{record} = $self->{current_line};
	$self->{current_line} = FALSE; # we're finished with this

	return $self->{record};
}

# read a line from the file handle
# note: this is overridden from parent, Reader
#       because we get our records differently
#       than basic text readers
=top
The record handling here deserves a consise description.
We need to:
  1. Read 14 bytes of BLOCK_HEADER to determine BLOCK_SIZE
    a. store BLOCK_SIZE in $self->{ama_block_size_bytes}
    b. store RECORDS in $self->{ama_records_in_block}
    c. track $self->{ama_block_bytes_read} after sysread (in BLOCK_HEADER)
    d. when $self->{ama_block_bytes_read} == BLOCK_SIZE get a new block
    e. get RECORD_HEADER ==> goto 2
  2. Read 22 bytes of RECORD_HEADER to determine RDW (this is the length of the AMA record including the RDW)
    a. store RECORD_LENGTH in $self->{ama_record_length} 
    b. track $self->{ama_record_header_bytes_read} after each sysread (in RECORD_HEADER)
    c. get CDR ==> goto 3
  3. Decode CDR
    a. increment $self->{ama_records_read}
    b. track $self->{ama_cdr_bytes_read} after each sysread (in CDR)
=cut
sub getNextLine
{
	my $self = shift;
	my $fh = $self->{fh};

	# STEP_1 : reading new block
	if (not defined($self->{ama_block_bytes_read}) or ($self->{ama_block_bytes_read} == 0))
	{
		$self->getNewBlock();
		return if ($self->{eof});
	}

	# STEP_2 : now that we have got all records in block .. get new block
	if 
	(
		defined($self->{ama_records_read}) and
		defined($self->{ama_records_in_block}) and
		($self->{ama_records_read} >= $self->{ama_records_in_block})
	)
	{
		my $bytesRemaining = ($self->{ama_block_size_bytes} - $self->{ama_block_bytes_read});
		my $record = $self->consumeRemainingBytes($bytesRemaining + 1);
		my $bytesConsumed = $record->{bytes_read}->{BYTES_CONSUMED} . "\n";
		# clear down vars .. indicators to get new block
		$self->{ama_block_bytes_read} = 0;
		$self->{get_records} = FALSE;
		$self->{ama_records_read} = 0;
		$self->{ama_records_in_block} = undef;

		$self->getNewBlock();
		return if ($self->{eof});
	}

	# STEP_3 : block has been read now get record header + record (CDR)
	if (defined($self->{get_records}))
	{
		my $recordHeader = $self->readRecordHeader();
		$self->{ama_record_length} = $recordHeader->{RECORD_DESCRIPTOR_WORD};
		my $record = $self->readCDRRecord();
		$self->{current_line} = $record;
		$self->{ama_records_read}++;
	}

	if (defined $self->{current_line})
	{
		$self->{records_read}++;
		$self->{input_file_obj}->incrementTotalLineCount();
		chomp($self->{current_line});
	}
	else
	{
		$self->{eof} = TRUE;
	}

	return $self->{current_line}; # just in case caller expects this value
}

sub getNewBlock
{
	my $self = shift;

	my $blockHeader = $self->readBlockHeader();
	$self->{ama_block_size_bytes} = $blockHeader->{BLOCK_SIZE};
	$self->{ama_records_in_block} = $blockHeader->{RECORDS};
	$self->{get_records} = TRUE;
	$self->{ama_records_read} = 0;
}

sub consumeRemainingBytes
{
	my $self = shift;
	my $bytesToConsume = shift;
	my $dummyFormat = [{name => "PADDING", bytes => $bytesToConsume}]; # need to pass ARRAY of HASHes

	return $self->readRecord($dummyFormat, BYTES_CONSUMED);
}


sub hex2num
{
	my $self = shift;
	my $hex = shift;

	return hex $hex;
}

sub bcd2num
{
	my $self = shift;
	my $buffer = shift;

	my $value = unpack("H*", $buffer);
	
	$value=~s/^f+//g;   # strip leading padding
	$value=~s/[cd]$//g; # strip training SUCCESS or FAILURE indicator
	return $value;
}

sub ebcdic2ascii
{
	my $self = shift;
	my $buffer = shift;

	my $value = Ascertain::UM::Readers::Convert::EBCDIC::ebcdic2ascii(unpack("a*", $buffer));
	$value =~ s/^\s+//; # strip leading space[s]
	$value =~ s/\s+$//; # strip trailing space[s]

	return $value;
}

sub timestamp2date
{
	my $self = shift;
	my $buffer = shift;

	my $value = $self->bcd2num($buffer);
	return undef unless (length($value));
	return strftime("%Y%m%d%H%M%S", localtime($value));
}

sub readBlockHeader
{
	my $self = shift;
	return $self->readRecord($self->{format_obj}->getBlockHeaderFormat(), BYTES_BLOCK_HEADER);
}

sub readRecordHeader
{
	my $self = shift;
	return $self->readRecord($self->{format_obj}->getRecordHeaderFormat(), BYTES_RECORD_HEADER);
}

sub readCDRRecord
{
	my $self = shift;
	return $self->readRecord($self->{format_obj}->getCdrFormat(), BYTES_CDR);
}

=top
N.B. this method is overwritten here because the 'decode' for AMA is part of the
     format, not the Aggregator. @SEE : Please see implementation in Reader.pm
     I don't want to call: $oAggregator->$func
     I want $oFormat->$func .. anyway that should already have been done by the format
=cut
sub getRecordAsCsv
{
	my $self = shift;
	my $oAggregator = shift;

	# get each fieldname from the format
	my @values;
	my $val;
	my $func;

	foreach my $f (@{$self->{format_obj}->getFormat()})
	{
		if (defined $self->{record}->{$f->{name}})
		{
			push @values, $self->{record}->{$f->{name}};
		}
		else 
		{
			push @values, (defined $self->{record}->{$f->{name}}) ? $self->{record}->{$f->{name}} : "NULL";
		}
	}
	my $record = join ",", @values;
	return $record;
}

=top
Use sysread to get bytes and decode using template from the oFormat object
@param $format A ref of ARAYY of HASH :: [{name =>, bytes =>, template =>, convert =>},...]
@param $bytesReadSection The section: BLOCK, HEADER, CDR : used to record bytes read in this section.
=cut
sub readRecord
{
	my $self = shift;
	my $format = shift;
	my $bytesReadSection = shift;

	my $fieldCount = scalar(@{$format});

	my $record = {};

	for (my $i = 0; $i < $fieldCount; $i++)
	{
		my $fieldName = $format->[$i]->{name};
		my $bytesToRead = $format->[$i]->{bytes};
		my $buffer;
		my $bytesRead = sysread($self->{fh}, $buffer, $bytesToRead);
		if ($bytesRead == 0) # EOF
		{
			$self->{current_line} = undef;
			$self->{eof} = TRUE;
			return; # bail
		}
		$self->{total_bytes_read} += $bytesRead;
		$self->{ama_block_bytes_read} += $bytesRead;
		my $value;
		my $template = $format->[$i]->{template};
		my $decode = $format->[$i]->{decode};

		# here we'll use a "conversion" method to provide actual values for things like 
		# EBCDIC encoded things and UNIX timestamp EPOCH dates to YYYYMMDDHH24MISS
		if (defined ($decode))
		{
			if ($self->can($decode))
			{
				no strict 'refs';
				$value = $self->$decode($buffer);	
			}
			else
			{
				$self->{logger}("Ooops This Class Can't, .. decode method [$decode] declared if format is not implemented in $self");
			}
		}
		elsif (defined $template)
		{
			$value = unpack($template, $buffer);
		}
		else # use default template
		{ 
			$value = unpack("H*",$buffer); #default if no template defined in format class
		}

		$record->{$fieldName} = $value;
		$record->{bytes_read}->{$bytesReadSection} += $bytesRead;
	}

	return $record;
}

#all modules do this
1;
