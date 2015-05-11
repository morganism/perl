package Ascertain::UM::VFI::Format::DS54;

use constant TRUE => 1;
use constant FALSE => undef;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);


sub init
{
	my $self = shift;

	$self->{type} = 'csv'; # csv fixedwidth asn1
	$self->{delimiter} = ',';
	$self->{has_header} = FALSE;
	#$self->{skip_header_lines} = 1;
	#$self->{header_regex} = qr/^$/;
	$self->{trim_values} = TRUE;
	$self->{has_trailer} = FALSE;
	#$self->{trailer_regex} = qr/^$/;
  $self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
  $self->{data_factor} = 1048576; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{name => 'subscriberType'},
		{name => 'RatingGroup'},
		{name => 'SubscriptionIdSubscriptionIdData'},
		{name => '3GPPChargingCharacteristics'},
		{name => '3GPPChargingID'},
		{name => '3GPPGGSNAddress'},
		{name => '3GPPGGSNMCCMNC'},
		{name => '3GPPGPRSQoSNegotiatedProfile'},
		{name => '3GPPIMSI'},
		{name => '3GPPIMSIMCCMNC'},
		{name => '3GPPNSAPI'},
		{name => '3GPPPDPType'},
		{name => '3GPPSGSNAddress'},
		{name => '3GPPSelectionMode'},
		{name => 'CalledStationId'},
		{name => 'ContextType'},
		{name => 'DestinationRealm'},
		{name => 'FramedIPAddress'},
		{name => 'OriginHost'},
		{name => 'OriginRealm'},
		{name => 'OriginStateId'},
		{name => 'RulebaseId'},
		{name => 'ServiceContextId'},
		{name => 'SessionId'},
		{name => 'TotalUSU'},
		{name => 'StartRecordTimeChar'},
		{name => 'StopRecordTimeChar'},
		{name => 'TotalUplink'},
		{name => 'TotalDownlink'},
		{name => 'CCN_SessionID'},
		{name => 'CCN_ExtInt1'},
		{name => 'IMEI'},
		{name => 'RecordSequenceNumber'},
		{name => 'FinalRecInd'},
		{name => 'AccidentalUsageFlag'},
		{name => 'CostInformationCCN'},
		{name => 'RadioAccessTechnology'},
	];

	$self->{format} = $format;
}



1;
