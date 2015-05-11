package Ascertain::UM::Readers::ASN1_Simple;

use strict;

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

# TRUE when 'current_line' is populated
# FALSE at endo of file
sub hasMoreRecords
{
	my $self = shift;
	my $openTag;

  	if (defined $self->{open_tag}) 
	{
		$openTag = $self->{open_tag};
	}
	else 
	{
		$openTag = "Not yet set. ";
	}

	$self->{debugger}( ( defined $self->{current_line} && $self->{current_line} =~ m:/$openTag: ) ? "found </$openTag>" : ( $self->{current_line} ? "return TRUE" : (  $self->{eof} ? "return FALSE" : "call getNextLine and recurse" ) ) );
	
	return TRUE if ( defined $self->{numInnerRecs} and  $self->{numInnerRecs} > 0 );
	return FALSE if ( defined $self->{current_line} && $self->{current_line} =~ m:/$openTag: );
	return FALSE if ($self->{eof});
	return TRUE  if ($self->{current_line});
		
	$self->getNextLine();
	return $self->hasMoreRecords();
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
		#$self->{input_file_obj}->incrementTotalLineCount();
		chomp($self->{current_line});
		# do not trim FIXED WIDTH
		if ($self->{type} ne READER_FIXED)
		{
			$self->{current_line} =~ s/^\s+//;
			$self->{current_line} =~ s/\s+$//;
		}
		
		$self->{debugger}( "setting current_line to:" . $self->{current_line} );
	}
	else
	{
		$self->{eof} = TRUE;
		$self->{debugger}( "setting EOF" );
	}
}

sub getRecord
{
	my $self = shift;
	
	if ( defined $self->{numInnerRecs} and  $self->{numInnerRecs} > 0 ) {
		
		$self->{record} = undef;
		my $rec = $self->{record_top_level};
		my $ir = pop(@{$self->{innerRecs}});
			
                foreach my $irKey (keys %$ir) {
                       $rec->{$irKey} = $ir->{$irKey};
                }

                $self->{numInnerRecs}--;
		$self->{record} = $rec;
	
		return $self->{record};
	}

	$self->{record} = undef;
	$self->{numInnerRecs} = undef;
	$self->{record_top_level} = undef;
	$self->{innerRecs} = undef;

	my $rec = {};
	my $done = 0;

	my $getRecordType = 0;
	my $fieldCount = 0;
	
	my $inInnerRec = 0;
	my $innerRecCount = 0;
	my $innerRec = {};
	my @innerRecs = ();

	my $startRecTag = $self->{asn_start_record_tag};
	my $endRecTag = $self->{asn_end_record_tag};
	my $openTag = $self->{asn_opening_tag};
	
	my $innerRecStartTag = $self->{asn_inner_start_record_tag};
	my $innerRecEndTag = $self->{asn_inner_end_record_tag};

	$self->{open_tag} = $openTag;


	while (not $done and $self->hasMoreRecords())
	{
	    
		$self->getNextLine();
		my $line = $self->{current_line};

		#------------------------------------------------------------
		# EOF
		#------------------------------------------------------------
		if (not defined $line or $line =~ m:/$openTag:)
		{
			$done = 1;
			$rec = undef unless ($fieldCount); 
			return undef;
		}
		$fieldCount++;
		chomp $line;
		$line =~ s:^\s+::; # strip leading whitespace
		$line =~ s:\s+$::; # strip trailing whitespace
		#------------------------------------------------------------

	
		#------------------------------------------------------------
		# RECORD_TYPE
		#------------------------------------------------------------
		if ($getRecordType)
		{
			$getRecordType = 0;
			$line =~ s:[ ><]::g;
			$rec->{recordType} = $line;
			next;
		}
		#------------------------------------------------------------

		
	
		#------------------------------------------------------------
		# next line is 'recordType'
		# will set in RECORD_TYPE section
		#------------------------------------------------------------
		if (not defined $rec->{recordType} and $line =~ m:(?<!/)$startRecTag:) # negative look behind, match startRecTag not preceded by /
		{
			$getRecordType = 1;
			next;
		}
		#------------------------------------------------------------
		# /$endRecTag is the end tag for this record
		#------------------------------------------------------------
		elsif ($line =~ m:/$endRecTag:)
		{
			$done = 1;
			$self->getNextLine();
			next;
		}
		elsif (defined $innerRecStartTag and $line =~ m:(?<!/)$innerRecStartTag:) # negative look behind, match innerRecStartTag not preceded by /
		{
			$inInnerRec = 1;
			$innerRecCount++;
			next;
		}
		elsif (defined $innerRecEndTag and $line =~ m:/$innerRecEndTag:)
		{
			$inInnerRec = 0;
			
			push(@innerRecs, $innerRec );
			$innerRec = undef;
			next;
		}
		#------------------------------------------------------------
		# any other TAG
		#------------------------------------------------------------
		else
		{
			#---------- Line may look like these examples ---------------
			#<callIdentificationNumber>48 6C 43</callIdentificationNumber>    :: SCALAR VALUE='48 6C 43'
			#<chargedParty><chargingOfCallingSubscriber/></chargedParty>      :: SCALAR VALUE='chargingOfCallingSubscriber'
			#<GenericDigits>20 00</GenericDigits>                             :: SCALAR VALUE='20 00'
			#<GenericDigits>01 04 30</GenericDigits>                          :: ARRAY  VALUE=['20 00', '01 04 30']
			#<iCIOrdered></iCIOrdered>                                        :: SCALAR VALUE='__PRESENT__'
			$line =~ m:^<([1-9A-Za-z-_]+)>(.*?)</\1>$:;
			my $key = $1;
			my $val = $2;

			if (defined $key) # we have a KEY
			{
				my $value = (not defined $val or not length($val)) ? "__PRESENT__" : $val;
				$value =~ s:[<>/]::g;
				
				if ($inInnerRec) {
					$innerRec->{$key} = $value;
				}
				else { 

					if (defined $rec->{$key})
					{
						if ($key =~ /Generic/) # hack, I know, but limit this to GenericDigits or GenericNumbers
						{
							if (ref ($rec->{$key}) eq "ARRAY")
							{
								push @{$rec->{$key}}, $value;
							}
							else
							{
								my $initialValue = $rec->{$key};
								$rec->{$key} = [$initialValue, $value];
							}
						}
					}
					else
					{
						$rec->{$key} = $value;
					}
				}
			}
		}
	}

	$self->{record_top_level} = $rec;

	if ($innerRecCount > 0) {
	
		my $ir = pop(@innerRecs);
		foreach my $irKey (keys %$ir) {
			$rec->{$irKey} = $ir->{$irKey};
		}

		$self->{innerRecs} = \@innerRecs;
		$self->{numInnerRecs} = $innerRecCount - 1;
	}

	$self->{record} = $rec;
	$self->{input_file_obj}->incrementTotalLineCount();
	return $self->{record};
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
