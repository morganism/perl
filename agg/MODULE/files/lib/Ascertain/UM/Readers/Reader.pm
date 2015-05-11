package Ascertain::UM::Readers::Reader;

use Data::Dumper;
use File::Basename;
use IO::File;

use Ascertain::UM::VFI::InvalidLine;

use constant READER_CSV   => "csv";
use constant READER_FIXED => "fixedwidth";
use constant READER_ASN1  => "asn1";

use constant FALSE => undef;
use constant TRUE  => 1;

sub new
{
	my $proto = shift;
	my $class = ref $proto || $proto;
	my $self  = {};
	my $args  = shift;
	$self->{data_source} = $args->{data_source};
	$self->{delimiter}   = $args->{delimiter};
	$self->{format_obj}  = $args->{format_obj};
	$self->{input_file_obj}  = $args->{input_file_obj};
	$self->{input_file}  = $args->{input_file_obj}->getFullPath();
	$self->{general_config} = $args->{general_config};
	$self->{logger}      = $args->{logger};
	$self->{debugger}    = $args->{debugger};
	$self->{type}        = $args->{type};
	
	$self->{no_open}     = $args->{no_open};
	$self->{no_trim}     = $args->{no_trim};

	$self->{asn_start_record_tag} =  $args->{asn_start_record_tag};
	$self->{asn_end_record_tag} =  $args->{asn_end_record_tag};
	$self->{asn_opening_tag} =  $args->{asn_opening_tag};

	# for convenience : could've got from input_file_obj, oh well 
	my ($edrFileName, $inputDir, $extension) = fileparse($self->{input_file});
	$self->{edrFileName} = $edrFileName;
	$self->{inputDir}    = $inputDir;

	# can't determine this at first for multis
	unless ($self->{format_obj}->isMultiFormat())
	{
		@{$self->{format_fields}} = map {$_->{name}} @{$self->{format_obj}->getFormat()};
		$self->{format_field_count} = scalar(@{$self->{format_fields}});
	}

	$self->{delimiter} = $self->{format_obj}->getDelimiter();
	$self->{isLenient} = $self->{format_obj}->isLenient();
	
	bless $self, $class;
	$self->{logger}("Creating Reader -> " . ref($self));
	$self->{records_read} = 0;

	$self->{invalid_line} = FALSE;
	$self->openFile() unless (defined $self->{no_open} and $self->{no_open} eq TRUE);

	return $self;
}

sub setFormatFields
{
	my $self = shift;
	@{$self->{format_fields}} = @_;
	$self->{format_field_count} = scalar(@{$self->{format_fields}});
}

sub getEdrFileName
{
	my $self = shift;
	return $self->{edrFileName};
}

sub getInputDir
{
	my $self = shift;
	return $self->{inputDir};
}

sub isRecordValid
{
	my $self = shift;
	return (not $self->{invalid_line});
}

sub openFile
{
	my $self = shift;

	my $inputFile = $self->{input_file};
	$inputFile =~ s:;:\\;:;
	my $fileOpenCommand = "cat " . $inputFile . '|';
	my $command = $self->getCompressionMethod();
	if ($command)
	{
		$fileOpenCommand = "$command " . $inputFile . '|';
		$self->{logger}("Opening compressed file as stream.");
	}
	$self->{debugger}("Opening file with command: $fileOpenCommand");
	open (my $fh, "$fileOpenCommand") or die "Reader.pm->openFile: Error opening file $fileOpenCommand : Reason[$!]";
	$self->{fh} = $fh;	

	# check for header instruction
	if ($self->{format_obj}->hasHeader())
	{
		$self->{debugger}("Format has a header.");
		if (defined $self->{format_obj}->{skip_header_lines})
		{
			$self->{debugger}("Skipping [" . $self->{format_obj}->{skip_header_lines} . "] header lines.");
			# consume the header lines
			my $i = 0;
			while (($i++ < $self->{format_obj}->{skip_header_lines}) and $self->hasMoreRecords())
			{
				my $lineNumber = $self->{records_read};
				my $oInvalidLine = new Ascertain::UM::VFI::InvalidLine({line_number => $lineNumber, data => $self->{current_line}});
				push @{$self->{invalid_lines}}, $oInvalidLine;
				$self->{current_line} = undef;
			}
		}
	}
	my $recordsRead = $self->{records_read} or 0;
	$self->{debugger}("Records read: $recordsRead");
}

sub getCompressionMethod
{
	my $self = shift;
	my $f = $self->{input_file};
	$f =~ s/\;/\\;/; # escape pesky ';'
	my $fileDetails = `file $f` or die "Could not execute 'file' against file : $f";
	chomp $fileDetails;
	$self->{debugger}("File details : $fileDetails");
	if ($fileDetails =~ /gzip compressed/)
	{
		return $self->{general_config}->{binary}->{gunzip}->{path};
	}
	elsif ($fileDetails =~ /compress'd data|compressed data block/)
	{
		return $self->{general_config}->{binary}->{uncompress}->{path};
	}
	return FALSE;		
}

# read a line from the file handle
sub getNextLine
{
	my $self = shift;
	my $fh = $self->{fh};
	$self->{current_line} = <$fh>;
	if (defined $self->{current_line})
	{
		$self->{records_read}++;
		$self->{input_file_obj}->incrementTotalLineCount();
		chomp($self->{current_line});
		# do not trim FIXED WIDTH
		if ($self->{type} ne READER_FIXED)
		{
			$self->{current_line} =~ s/^\s+//;
			$self->{current_line} =~ s/\s+$//;
		}
	}
	else
	{
		$self->{eof} = TRUE;
	}
	return $self->{current_line}; # just in case caller expects this value
}

# TRUE when 'current_line' is populated
# FALSE at endo of file
sub hasMoreRecords
{
	my $self = shift;
	return TRUE  if ($self->{current_line});
	return FALSE if ($self->{eof});
	
	$self->getNextLine();
	return $self->hasMoreRecords();
}

sub getRecordsRead
{
	my $self = shift;
	return $self->{records_read};
}

sub setRecordsRead
{
	my $self = shift;
	$self->{records_read} = shift;
}

# return the records marked as 'invalid'
# could be header, trailer, or bad
sub getInvalids
{
	my $self = shift;
	$self->{debugger}("Returning array of invalid lines.");
	my @invalidLines = (defined $self->{invalid_lines}) ? @{$self->{invalid_lines}} : ();
	my $invalidCount = scalar(@invalidLines);
	$self->{debugger}("Returning $invalidCount invalid lines.");
	return @invalidLines;
}

sub setInvalids
{
	my $self = shift;
	$self->{debugger}("Returning array of invalid lines.");
	@{$self->{invalid_lines}} = @_;
}

sub incrementErrorCount
{
	my $self = shift;
	$self->{error_count}++;
}

sub print
{
	my $self = shift;
	
	# get each fieldname from the format
	print "-" x 70 . "\n";
	printf "-%10s%10s\n", "RECORD", $self->{records_read};
	print "-" x 70 . "\n";
	foreach my $f (@{$self->{format_obj}->getFormat()})
	{
		my $value = (defined $self->{record}->{$f->{name}}) ? $self->{record}->{$f->{name}} : "NULL";
		printf "%-40s%30s\n", $f->{name}, "[$value]"; 
	}
	print "-" x 70 . "\n\n";
}

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
		if (defined $self->{record}->{$f->{name}} && 
		    defined $f->{decode}) {
			$func = $f->{decode};
			my $val = $oAggregator->$func($self->{record}->{$f->{name}});	
			push @values, $val;
		}
		else {
			push @values, (defined $self->{record}->{$f->{name}}) ? $self->{record}->{$f->{name}} : "NULL";
		}
	}
	my $record = join ",", @values;
	return $record;
}

sub getFieldNamesAsCsv
{
	my $self = shift;
	
	# get each fieldname from the format
	my @values;
	foreach my $f (@{$self->{format_obj}->getFormat()})
	{
		push @values, $f->{name};
	}
	my $record = join ",", @values;
	return $record;
}

# this is for testing, it takes the output of print() and generates the record
# that was printed in the appropriate format
sub unPrint
{
	my $self = shift;
	my $fullPath = $self->{input_file_obj}->getFullPath();
	my $record = {};
	my $counter = 0;
	open IN, $fullPath;
	while (<IN>)
	{
		chomp;
		next if (/^\s*$/);
		if (/^-\s+RECORD\s+\d+/)
		{
			if ($counter++)
			{
				$self->unPrinter($record);
				$record = {};
			}
			next;
		}
		next if (/^-/);
		/^([^\s]+)\s+\[(.*)\]/;
		my $k = $1;
		my $v = $2;
		$v =~ s/[\[\]]//g;
		$record->{$k} = $v;
	}
	close IN;
	$self->unPrinter($record);
}
sub unPrinter
{
	my $self = shift;
	my $record = shift;
	my $delimiter = 
		(defined $self->{format_obj}->getDelimiter()) ? $self->{format_obj}->getDelimiter() : ",";
	my $output = "";
	my $counter = 0;
	my $type = $self->{format_obj}->getType();

	foreach my $f (@{$self->{format_obj}->getFormat()})
	{
		my $bytes = $f->{bytes};
		my $value = (defined $record->{$f->{name}}) ? $record->{$f->{name}} : "";
		if ($type eq READER_FIXED) # FixedWidth
		{
			$output .= sprintf "%-${bytes}s", $value;
		}
		elsif ($type eq READER_CSV)
		{
			$value = "" if ($value eq "NULL"); # undo this convenience
			$output .= $delimiter if ($counter++); #prepend delim after field 1
			$output .= $value;
		}
		else
		{
			die("Unsupported format type : $type.");
		}
	}
	print "$output\n";
	
}

1;
