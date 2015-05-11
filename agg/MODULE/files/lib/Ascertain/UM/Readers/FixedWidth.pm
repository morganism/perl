package Ascertain::UM::Readers::FixedWidth;

use Data::Dumper;

use lib "$ENV{AGGREGATOR_BUILD}/lib";
use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::Readers::Reader);

use IO::File;

use Ascertain::UM::VFI::InvalidLine;

use constant FALSE => undef;
use constant TRUE  => 1;

sub getRecord
{
	my $self = shift;

	return FALSE unless ($self->hasMoreRecords()); 
	my $lineLength = length($self->{current_line});

	if ($self->{format_obj}->isMultiFormat())
	{
		$self->setFormat();
	}

	my $offset = 0;
	my $record = {};

	
	if ($self->{format_obj}->isLenient())
	{
		my $trailerRexeg = $self->{format_obj}->getTrailerRegex();
		if ($self->{current_line} =~ /$trailerRexeg/)
		{
			$self->{logger}("Skipping trailer that matches trailerRexeg [$trailerRexeg]: [$self->{current_line}].");
			$self->{current_line} = FALSE; # we're finished with this
			return $record;
		}
	}
	else
	{
		my $formatLineLength = 
			(defined $self->{format_line_length}) 
				? $self->{format_line_length}
				: $self->setFormatLineLength();
		$self->{invalid_line} =
			($lineLength != $formatLineLength) ? TRUE : FALSE;
		if ($self->{invalid_line})
		{
			my $lineNumber = $self->{records_read};
			$self->{debugger}("Current line [" . $self->{records_read} . "] is [$lineLength] bytes not [$formatLineLength] bytes");
			my $oInvalidLine = new Ascertain::UM::VFI::InvalidLine({line_number => $lineNumber, data => $self->{current_line}});
			push @{$self->{invalid_lines}}, $oInvalidLine;
			$self->{current_line} = FALSE; # we're finished with this
			$self->{input_file_obj}->incrementInvalidLineCount(); # inc for each invalid
			return $record;
		}
	}
	foreach my $f (@{$self->{format_obj}->getFormat()})
	{
		my $line = $self->{current_line};
		my $name = $f->{name};
		my $bytes = $f->{bytes};
		my $value = substr($line, $offset, $bytes);
		my $trim = ($self->{format_obj}->{trim_values} and not $self->{no_trim}); # don't trim if we set no_trim in the Reader, even if it is set in the format
		if ($trim)
		{
			$value =~ s/^\s*//;
			$value =~ s/\s*$//;
		}
		$record->{$name} = (length $value) ? $value : undef; # 
		$offset += $f->{bytes};
	}

	$self->{current_line} = FALSE; # we're finished with this
	$self->{record} = $record;
	return $record;
}

sub setFormat
{
	my $self = shift;

	my $offset = 0;
	my $record = {};

	my $lineLength = length($self->{current_line});
	my $formatLable = substr($self->{current_line}, 0, 15);
	$formatLable =~ s/^\s+//;
	$formatLable =~ s/\s+$//;
	$self->{format_obj}->setFormat({record_type => $formatLable, line_length => $lineLength});
	$self->setFormatLineLength();
}

sub setFormatLineLength
{
	my $self = shift;
	my $formatLineLength = 0;
	map {$formatLineLength += $_->{bytes}} @{$self->{format_obj}->getFormat()};
	$self->{format_line_length} = $formatLineLength;
}

1;
