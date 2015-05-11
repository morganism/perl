package Ascertain::UM::VFI::Format::DS80;

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

	$self->{has_header} = FALSE;
	#$self->{skip_header_lines} = 6;

	#$self->{has_trailer} = FALSE;
  $self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
  $self->{data_factor} = 1; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{name => 'subscriberType'},
		{name => 'RatingGroup'},
		{name => 'Subscription_Id_Subscription_Id_Data'},
		{name => '3GPP_User_Location_Info'},
		{name => 'Application_Server'},
		{name => 'Calling_Party_Address'},
		{name => 'Called_Party_Adreess'},
		{name => 'Destination_Realm'},
		{name => 'Origin_Host'},
		{name => 'Origin_Realm'},
		{name => 'Origin_State_Id'},
		{name => 'Requested_Party_Adress'},
		{name => 'Application_provided_Called_Party_Address'},
		{name => 'User_Session_Id'},
		{name => 'Service_Context_Id'},
		{name => 'Session_Id'},
		{name => 'TotalUSU'},
		{name => 'StartRecordTimeChar'},
		{name => 'StopRecordTimeChar'},
		{name => 'CCN_SessionID'},
		{name => 'CCN_ServiceID'},
		{name => 'RecordSequenceNumber'},
		{name => 'FinalRecInd'},
		{name => 'accidentalUsageFlag'},
		{name => 'CostInformationCCN'},
		{name => 'MCC_MNC'},
		{name => 'CC_NDC'},
		{name => 'TeleServiCode'},
		{name => 'TraffiCase'},
	];

	$self->{format} = $format;
}



1;
