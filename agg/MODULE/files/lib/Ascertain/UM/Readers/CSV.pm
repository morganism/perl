package Ascertain::UM::Readers::CSV;


use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::Readers::Reader);

use IO::File;

use Ascertain::UM::VFI::InvalidLine;

use constant FALSE => undef;
use constant TRUE  => 1;
use constant PRESERVE_TRAILING_NULLS => -1; # stop 'split' from stripping null values at end of record: i.e. a,b,c,,,

sub getRecord
{
	my $self = shift;

	#return FALSE unless ($self->hasMoreRecords()); 
	
	my $delim = $self->{delimiter};
	my @fields = split /$delim/, $self->{current_line}, PRESERVE_TRAILING_NULLS;
	my $fieldCount = scalar(@fields);
	my $formatFieldCount = $self->{format_field_count};

	# don't validate field count if format is lenient
	unless ($self->{isLenient})
	{
		$self->{invalid_line} =
			($fieldCount != $formatFieldCount) ? TRUE : FALSE;

		# these could be header, trailer, or invalid check later
		if ($self->{invalid_line})
		{
			my $lineNumber = $self->{records_read};
			my $oInvalidLine = new Ascertain::UM::VFI::InvalidLine({line_number => $lineNumber, data => $self->{current_line}});
			push @{$self->{invalid_lines}}, $oInvalidLine;
			$self->{input_file_obj}->incrementInvalidLineCount(); # inc for each invalid
			$self->{debugger}("Format does not match input: format expects $formatFieldCount fields, got $fieldCount from input files");
		}
	}

	my @formatFields = @{$self->{format_fields}};
	my $record = {};
	for (my $i = 0; $i < scalar(@formatFields); $i++)
	{
		my $value = (defined $fields[$i]) ? $fields[$i] : "";
		my $trim = ($self->{format_obj}->{trim_values} and not $self->{no_trim}); # don't trim if we set no_trim in the Reader, even if it is set in the format
		if ($trim)
		{
			$value =~ s/^\s*//;
			$value =~ s/\s*$//;
		}
		$record->{$formatFields[$i]} = (length $value) ? $value : undef;
	}
	
	$self->{current_line} = FALSE; # we're finished with this

	$self->{record} = $record;
	return $record;
}

1;
