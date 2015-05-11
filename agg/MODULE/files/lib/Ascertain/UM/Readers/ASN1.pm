package Ascertain::UM::Readers::ASN1;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::Readers::Reader);

use Data::Dumper;
use File::Basename;
use IO::File;
use XML::Simple;

use Ascertain::UM::VFI::InvalidLine;

use constant READER_CSV   => "csv";
use constant READER_FIXED => "fixedwidth";
use constant READER_ASN1  => "asn1";

use constant FALSE => undef;
use constant TRUE  => 1;

use constant OFFSET_FIELD_NAME => -1;
use constant OFFSET_RECORD_TYPE => -2;

sub getRecord
{
	my $self = shift;
	my $line = $self->{current_line};
	$self->{current_line} = undef;
	$self->{record} = undef;
	my $keysSoFar;
	$self->recurseHash($line, $keysSoFar);
	return $self->{record};
}

# drill down to a value (SCALAR or ARRAY) and associate it with all the parent keys
# this can be a:
# hash of hash for a simple record (yeah, I know, 'simple')
# or a hash of hash of array of hash for composite
sub recurseHash
{
	my $self = shift;
  my($refhash,$keysofar)=@_;
	my $type = ref ($refhash);
	if ($type eq "HASH") # we're a HASH, check each key
	{
		# for each key in the hash check to see if we have to keep drilling or we have a value
		my @hashKeys = sort keys %{$refhash};

		# this is when a hash key is actually the value for the previous key (I think)
		# EXAMPLE
		# 'chargedParty' => {
		#		 'chargingOfCallingSubscriber' => {}
		#	 },
		# the KEY is chargedParty, the VALUE is chargingOfCallingSubscriber
		# and 
		# the KEY is chargingOfCallingSubscriber, the VALUE is __PRESENT__
		if ((scalar @hashKeys) == 0)
		{
			my @k = split /:/, $keysofar; # last elt is value
			my $value = pop(@k);
			$value =~ s/^\s+//;
			$value =~ s/\s+$//;
			my $shortKey = $k[OFFSET_FIELD_NAME]; # -1

			#if ((not defined $self->{record}->{$shortKey}) and (length($value)))
			if (not defined $self->{record}->{$shortKey}) # add any found fields
			{
				# don't stomp on existing values, and don't add zero width (null) values, again stomp
				$self->{record}->{$shortKey} = $value;
				$self->{record}->{$value} = "__PRESENT__";
			}
		}

		for(@hashKeys)
		{
			if(ref $$refhash{$_}) # keep drilling, could be HASH or ARRAY
			{
				my $keys = (defined ($keysofar)) ? "$keysofar:$_" : $_; # use list of keys or $_ for first value first time thru
				$self->recurseHash($$refhash{$_}, $keys);
			}
			else # we have values su use them to populate the record
			{
				my $keys = (defined ($keysofar)) ? "$keysofar:$_:$$refhash{$_}" : "$_:$$refhash{$_}";
				#push @{$self->{record}}, $keys;
				my @k = split /:/, $keys; # last elt is value
				my $value = pop(@k);
				$value =~ s/^\s+//;
				$value =~ s/\s+$//;
				my $shortKey = $k[OFFSET_FIELD_NAME]; # -1
				my $recordType = $k[OFFSET_RECORD_TYPE]; # -2
				my $longKey = join ":", @k;
				$self->{record}->{recordType} = $recordType unless (defined $self->{record}->{recordType});
				#if ((not defined $self->{record}->{$shortKey}) and (length($value)))
				if (not defined $self->{record}->{$shortKey}) # add any found fields
				{
					# don't stomp on existing values, and don't add zero width (null) values, again stomp
					$self->{record}->{$shortKey} = $value;
				}
			}
		}
	}
	elsif ($type eq "ARRAY") # could be composite or value could be list
	{
		foreach my $element (@{$refhash})
		{
			# composite record
			if (ref ($element))
			{
				$self->recurseHash($element, $keysofar);
			}
			else
			{
				my @k = split /:/, $keysofar; # last elt is value
				my $shortKey = $k[OFFSET_FIELD_NAME]; # -1
				$self->{record}->{$shortKey} = $refhash;
			} 
		}
	}
}


sub openFile
{
	my $self = shift;

	my $wholeFile = XMLin($self->{input_file},forcearray => [qw(CallDataRecord)]);
	$self->{all_records} = $wholeFile->{CallDataRecord};
	my $recordCount = (defined $self->{all_records}) ? scalar(@{$self->{all_records}}) : 0;
}


# read a line from the file handle
sub getNextLine
{
	my $self = shift;
	$self->{current_line} = shift @{$self->{all_records}};
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

sub print
{
	my $self = shift;
	
	# get each fieldname from the format
	print "-" x 80 . "\n";
	printf "-%10s%10s\n", "RECORD", $self->{records_read};
	print "-" x 80 . "\n";
	foreach my $f (@{$self->{format_obj}->getFormat()})
	{
		my $value = (defined $self->{record}->{$f->{name}}) ? $self->{record}->{$f->{name}} : "";
		if (ref($value) eq "ARRAY")
		{
			foreach my $v (@{$value})
			{
				printf "%-40s%40s\n", $f->{name}, $v; 
			}
		}	
		else
		{
			printf "%-40s%40s\n", $f->{name}, $value; 
		}
	}
	print "-" x 60 . "\n\n";
}

1;
