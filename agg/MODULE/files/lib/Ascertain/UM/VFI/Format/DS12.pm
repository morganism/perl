package Ascertain::UM::VFI::Format::DS12;

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
	$self->{skip_header_lines} = 1;
	$self->{header_regex} = '^AcceptTime';
  $self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
  $self->{data_factor} = 1; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{name => 'AcceptTime'},
		{name => 'Audit_Block_ID'},
		{name => 'Audit_Source_ID'},
		{name => 'CallDirection'},
		{name => 'CallReference'},
		{name => 'CalledNpi'},
		{name => 'CalledSubscriberImsi'},
		{name => 'CallingNpi'},
		{name => 'CallingPartyNumber'},
		{name => 'ClosedUserGroup'},
		{name => 'CugType'},
		{name => 'DestinationAddress'},
		{name => 'DestinationImsi'},
		{name => 'DestinationNode'},
		{name => 'DestinationSme'},
		{name => 'Distribution'},
		{name => 'FirstInBatch'},
		{name => 'MessageDeliveryTime'},
		{name => 'MessageDeliveryTimeZone'},
		{name => 'MessageReferenceType'},
		{name => 'MessageSource'},
		{name => 'MessageSubmissionTime'},
		{name => 'MessageSubmissionTimeZone'},
		{name => 'OriginatingAddress'},
		{name => 'OriginatingImsi'},
		{name => 'Other_1'},
		{name => 'Other_10'},
		{name => 'Other_11'},
		{name => 'Other_14'},
		{name => 'Other_15'},
		{name => 'Other_16'},
		{name => 'Other_17'},
		{name => 'Other_18'},
		{name => 'Other_19'},
		{name => 'Other_2'},
		{name => 'Other_20'},
		{name => 'Other_21'},
		{name => 'Other_22'},
		{name => 'Other_23'},
		{name => 'Other_24'},
		{name => 'Other_25'},
		{name => 'Other_26'},
		{name => 'Other_3'},
		{name => 'Other_4'},
		{name => 'Other_5'},
		{name => 'Other_6'},
		{name => 'Other_7'},
		{name => 'Other_8'},
		{name => 'Other_9'},
		{name => 'RecordType'},
		{name => 'SmeMessageReference'},
		{name => 'SourceNode'},
		{name => 'SubLogicalSme'},
		{name => 'TrafficEventTime'},
		{name => 'TrafficEventType'},
	];

	$self->{format} = $format;
}



1;
