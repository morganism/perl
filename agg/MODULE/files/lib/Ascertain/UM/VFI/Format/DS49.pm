package Ascertain::UM::VFI::Format::DS49;

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
	$self->{header_regex} = qr/^ASN1BlockNumber/;

	$self->{has_trailer} = FALSE;
  $self->{currency_factor} = 100; # if in euros then 100, if in cents then 1
  $self->{data_factor} = 1; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{name => 'ASN1BlockNumber'},
		{name => 'CCN_AbnormalTerminationReason'},
		{name => 'CCN_AccountGroupID'},
		{name => 'CCN_AccountNumber'},
		{name => 'CCN_AccountValueAfter'},
		{name => 'CCN_AccountValueBefore'},
		{name => 'CCN_AccountingCorrelationID'},
		{name => 'CCN_AccumulatorDeltaValue'},
		{name => 'CCN_AccumulatorID'},
		{name => 'CCN_AccumulatorValue1'},
		{name => 'CCN_AccumulatorValue10'},
		{name => 'CCN_AccumulatorValue2'},
		{name => 'CCN_AccumulatorValue3'},
		{name => 'CCN_AccumulatorValue4'},
		{name => 'CCN_AccumulatorValue5'},
		{name => 'CCN_AccumulatorValue6'},
		{name => 'CCN_AccumulatorValue7'},
		{name => 'CCN_AccumulatorValue8'},
		{name => 'CCN_AccumulatorValue9'},
		{name => 'CCN_CalledPartyNumber'},
		{name => 'CCN_CalledPartyNumber2'},
		{name => 'CCN_CalledPartyNumber3'},
		{name => 'CCN_CallingPartyNumber'},
		{name => 'CCN_CdrType'},
		{name => 'CCN_ChargedDuration'},
		{name => 'CCN_CommunityDataNonChargedNotAvailable'},
		{name => 'CCN_CommunityID1Charged'},
		{name => 'CCN_CommunityID1NonCharged'},
		{name => 'CCN_CommunityID2Charged'},
		{name => 'CCN_CommunityID2NonCharged'},
		{name => 'CCN_CommunityID3Charged'},
		{name => 'CCN_CommunityID3NonCharged'},
		{name => 'CCN_CurrencyType'},
		{name => 'CCN_DAFifthAccDuration'},
		{name => 'CCN_DAFifthCampaignIdentifier'},
		{name => 'CCN_DAFifthID'},
		{name => 'CCN_DAFifthValueAfter'},
		{name => 'CCN_DAFifthValueBefore'},
		{name => 'CCN_DAFirstAccDuration'},
		{name => 'CCN_DAFirstCampaignIdentifier'},
		{name => 'CCN_DAFirstID'},
		{name => 'CCN_DAFirstValueAfter'},
		{name => 'CCN_DAFirstValueBefore'},
		{name => 'CCN_DAFourthAccDuration'},
		{name => 'CCN_DAFourthCampaignIdentifier'},
		{name => 'CCN_DAFourthID'},
		{name => 'CCN_DAFourthValueAfter'},
		{name => 'CCN_DAFourthValueBefore'},
		{name => 'CCN_DASecondAccDuration'},
		{name => 'CCN_DASecondCampaignIdentifier'},
		{name => 'CCN_DASecondID'},
		{name => 'CCN_DASecondValueAfter'},
		{name => 'CCN_DASecondValueBefore'},
		{name => 'CCN_DAThirdAccDuration'},
		{name => 'CCN_DAThirdCampaignIdentifier'},
		{name => 'CCN_DAThirdID'},
		{name => 'CCN_DAThirdValueAfter'},
		{name => 'CCN_DAThirdValueBefore'},
		{name => 'CCN_DataVolume'},
		{name => 'CCN_DeductedAmountLastInterval'},
		{name => 'CCN_ExtInt1'},
		{name => 'CCN_ExtInt2'},
		{name => 'CCN_ExtInt3'},
		{name => 'CCN_ExtInt4'},
		{name => 'CCN_ExtText'},
		{name => 'CCN_FamilyAndFriendsIndicator'},
		{name => 'CCN_Filename'},
		{name => 'CCN_FinalCharge'},
		{name => 'CCN_GprsQoS'},
		{name => 'CCN_LastPartialOutput'},
		{name => 'CCN_LocalSequenceNumber'},
		{name => 'CCN_MultiSessionID'},
		{name => 'CCN_NetworkID'},
		{name => 'CCN_NodeID'},
		{name => 'CCN_NumberOfEvents'},
		{name => 'CCN_NumberOfSDPInterrogations'},
		{name => 'CCN_OriginHost'},
		{name => 'CCN_OriginRealm'},
		{name => 'CCN_OriginalSubscriptionIDData'},
		{name => 'CCN_OriginalSubscriptionIDType'},
		{name => 'CCN_OriginatingLocationInfo'},
		{name => 'CCN_RadiusSessionID'},
		{name => 'CCN_RecordSequenceNumber'},
		{name => 'CCN_RedirectingPartyNumber'},
		{name => 'CCN_SelectedCommunityIndicator'},
		{name => 'CCN_ServiceClass'},
		{name => 'CCN_ServiceOfferings'},
		{name => 'CCN_ServiceProviderID'},
		{name => 'CCN_SessionID'},
		{name => 'CCN_SmsDeliveryStatus'},
		{name => 'CCN_SubscriberID'},
		{name => 'CCN_SubscriptionType'},
		{name => 'CCN_TeleServiceCode'},
		{name => 'CCN_TerminatingLocationInfo'},
		{name => 'CCN_TrafficCase'},
		{name => 'CCN_TriggerTime'},
		{name => 'CCN_TriggerTimeHoursOffset'},
		{name => 'CCN_TriggerTimeMinutesOffset'},
		{name => 'CCN_TriggerTimeNegativeTZ'},
		{name => 'CCN_UsedAmountLastInterval'},
		{name => 'CCN_UserName'},
		{name => 'CallDetailOutputRecord'}
	];

	$self->{format} = $format;
}



1;
