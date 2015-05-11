package Ascertain::UM::VFI::Format::DS81;

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
		{name => 'RecordType'},
		{name => 'Call_Direction'},
		{name => 'Call_Type'},
		{name => 'Call_Service'},
		{name => 'Network_Location'},
		{name => 'File_name'},
		{name => 'A_Calling_Party_IMSI'},
		{name => 'B_Forwarding_Party_IMSI'},
		{name => 'C_Called_party_IMSi'},
		{name => 'A_Calling_Party_MSISDN'},
		{name => 'B_Forwarding_Party_MSISDN'},
		{name => 'C_Called_party_MSISDN'},
		{name => 'subscriberType'},
		{name => 'RatingGroup'},
		{name => 'Subscription_Id_Subscription_Id_Data'},
		{name => '3GPP_User_Location_Info'},
		{name => 'Application_Server'},
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
		{name => 'CCN_balance_before'},
		{name => 'CCN_balance_after'},
		{name => 'CCN_Currency_Type'},
		{name => 'CCN_final_charge'},
		{name => 'CCN_AccumulatorValue1'},
		{name => 'CCN_DAFirstValueBefore'},
		{name => 'CCN_DAFirstValueAfter'},
		{name => 'CCN_DAFirstAccDuration'},
		{name => 'CCN_DAFirstID'},
		{name => 'CCN_DAFirstCampaignIdentifier'},
		{name => 'CCN_DASecondValueBefore'},
		{name => 'CCN_DASecondValueAfter'},
		{name => 'CCN_DASecondAccDuration'},
		{name => 'CCN_DASecondID'},
		{name => 'CCN_DASecondCampaignIdentifier'},
		{name => 'CCN_DAThirdValueBefore'},
		{name => 'CCN_DAThirdValueAfter'},
		{name => 'CCN_DAThirdAccDuration'},
		{name => 'CCN_DAThirdID'},
		{name => 'CCN_DAThirdCampaignIdentifier'},
		{name => 'CCN_DAFourthValueBefore'},
		{name => 'CCN_DAFourthValueAfter'},
		{name => 'CCN_DAFourthAccDuration'},
		{name => 'CCN_DAFourthID'},
		{name => 'CCN_DAFourthCampaignIdentifier'},
		{name => 'CCN_DAFifthValueBefore'},
		{name => 'CCN_DAFifthValueAfter'},
		{name => 'CCN_DAFifthAccDuration'},
		{name => 'CCN_DAFifthID'},
		{name => 'CCN_DAFifthCampaignIdentifier'},
		{name => 'CCN_DAFirstBalanceBeforeCurrency'},
		{name => 'CCN_DAFirstBalanceAfterCurrency'},
		{name => 'CCN_DAFirstCalculatedPriceVat'},
		{name => 'CCN_DASecondBalanceBeforeCurrency'},
		{name => 'CCN_DASecondBalanceAfterCurrency'},
		{name => 'CCN_DASecondCalculatedPriceVat'},
		{name => 'CCN_DAThirdBalanceBeforeCurrency'},
		{name => 'CCN_DAThirdBalanceAfterCurrency'},
		{name => 'CCN_DAThirdCalculatedPriceVat'},
		{name => 'CCN_DAFourthBalanceBeforeCurrency'},
		{name => 'CCN_DAFourthBalanceAfterCurrency'},
		{name => 'CCN_DAFourthCalculatedPriceVat'},
		{name => 'CCN_DAFifthBalanceBeforeCurrency'},
		{name => 'CCN_DAFifthBalanceAfterCurrency'},
		{name => 'CCN_DAFifthCalculatedPriceVat'},
	];

	$self->{format} = $format;
}



1;
