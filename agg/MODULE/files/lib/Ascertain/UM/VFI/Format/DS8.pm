package Ascertain::UM::VFI::Format::DS8;

use constant TRUE => 1;
use constant FALSE => undef;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);

sub init
{
	my $self = shift;

	$self->{type} = 'csv';
	$self->{delimiter} = ',';
	$self->{trim_values} = TRUE;

	$self->{has_header} = TRUE;
	$self->{skip_header_lines} = 6;

	$self->{has_trailer} = FALSE;
  $self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
  $self->{data_factor} = 1; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{name => 'TrafficEventType', bytes => -1},
		{name => 'TrafficEventTime', bytes => -1},
		{name => 'MessageSource', bytes => -1},
		{name => 'OriginatingAddress', bytes => -1},
		{name => 'DestinationAddress', bytes => -1},
		{name => 'DestinationSME', bytes => -1},
		{name => 'AcceptTime', bytes => -1},
		{name => 'FirstinBatch', bytes => -1},
		{name => 'CallDirection', bytes => -1},
		{name => 'PrepaidServerIdentity', bytes => -1},
		{name => 'DestinationIMSI', bytes => -1},
		{name => 'ClosedUserGroup', bytes => -1},
		{name => 'CUGType', bytes => -1},
		{name => 'MessageReferenceType', bytes => -1},
		{name => 'SMEMessageReference', bytes => -1},
		{name => 'OriginatingIMSI', bytes => -1},
		{name => 'Other1', bytes => -1},
		{name => 'Other2', bytes => -1},
		{name => 'Other3', bytes => -1},
		{name => 'Other4', bytes => -1},
		{name => 'Other5', bytes => -1},
		{name => 'Other6', bytes => -1},
		{name => 'Other7', bytes => -1},
		{name => 'Other8', bytes => -1},
		{name => 'Other9', bytes => -1},
		{name => 'Other10', bytes => -1},
		{name => 'Other11', bytes => -1},
		{name => 'SourceNode', bytes => -1},
		{name => 'DestinationNode', bytes => -1},
		{name => 'Other14', bytes => -1},
		{name => 'Other15', bytes => -1},
		{name => 'Other16', bytes => -1},
		{name => 'Other17', bytes => -1},
		{name => 'Other18', bytes => -1},
		{name => 'Other19', bytes => -1},
		{name => 'Other20', bytes => -1},
		{name => 'Other21', bytes => -1},
		{name => 'Other22', bytes => -1},
		{name => 'Other23', bytes => -1},
		{name => 'Other24', bytes => -1},
		{name => 'Other25', bytes => -1},
		{name => 'Other26', bytes => -1}
	];

	$self->{format} = $format;
}



1;
