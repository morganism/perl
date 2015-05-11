package Ascertain::UM::VFI::Format::DS56;

use constant TRUE => 1;
use constant FALSE => undef;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);


sub init
{
	my $self = shift;

	$self->{type} = 'csv'; # csv fixedwidth asn1
	$self->{delimiter} = ','; # csv fixedwidth asn1
	$self->{has_header} = TRUE;
	$self->{skip_header_lines} = 1;
	$self->{header_regex} = qr/^ngmeRecordType/;
	$self->{trim_values} = TRUE;
	$self->{has_trailer} = FALSE;
  $self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
  $self->{data_factor} = 1048576; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{name => 'ngmeRecordType'},
		{name => 'networkInitiation'},
		{name => 'servedIMSI'},
		{name => 'ASN1OutputRecord.ggsnAddress'},
		{name => 'chargingID_long'},
		{name => 'sgsnAddress'},
		{name => 'accessPointNameNI'},
		{name => 'pdpType'},
		{name => 'ASN1OutputRecord.servedPDPAddress'},
		{name => 'dynamicAddressFlag'},
		{name => 'TrafVol_qosRequested'},
		{name => 'TrafVol_qosNegotiated'},
		{name => 'TrafVol_dataVolumeGPRSUplink'},
		{name => 'TrafVol_dataVolumeGPRSDownlink'},
		{name => 'TrafVol_changeCondition'},
		{name => 'TrafVol_changeTime'},
		{name => 'TrafVol_failureHandlingContinue'},
		{name => 'recordOpeningTime'},
		{name => 'duration'},
		{name => 'causeForRecClosing'},
		{name => 'diagnostics'},
		{name => 'recordSequenceNumber'},
		{name => 'nodeID'},
		{name => 'recordExtensions'},
		{name => 'localSequenceNumber'},
		{name => 'apnSelectionMode'},
		{name => 'servedMSISDN'},
		{name => 'chargingCharacteristics'},
		{name => 'chChSelectionMode'},
		{name => 'iMSsignalingContext'},
		{name => 'externalChargingID'},
		{name => 'sgsnPLMNIdentifier'},
		{name => 'pSFurnishChargingInformation'},
		{name => 'servedIMEISV'},
		{name => 'rATType'},
		{name => 'mSTimeZone'},
		{name => 'userLocationInformation'},
		{name => 'cAMELChargingInformation'},
		{name => 'ServCond_ratingGroup'},
		{name => 'ServCond_chargingRuleBaseName'},
		{name => 'ServCond_resultCode'},
		{name => 'ServCond_localSequenceNumber'},
		{name => 'ServCond_timeOfFirstUsage'},
		{name => 'ServCond_timeOfLastUsage'},
		{name => 'ServCond_timeUsage'},
		{name => 'ServCond_serviceConditionChange'},
		{name => 'ServCond_qoSInformationNeg'},
		{name => 'ASN1OutputRecord.ServCond_sgsn-Address'},
		{name => 'ServCond_sGSNPLMNIdentifier'},
		{name => 'ServCond_datavolumeFBCUplink'},
		{name => 'ServCond_datavolumeFBCDownlink'},
		{name => 'ServCond_timeOfReport'},
		{name => 'ServCond_rATType'},
		{name => 'ServCond_failureHandlingContinue'},
		{name => 'ServCond_serviceIdentifier'},
		{name => 'ServCond_pSFurnishChargingInformation'}
	];

	$self->{format} = $format;
}



1;
