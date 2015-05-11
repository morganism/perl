package Ascertain::UM::VFI::Format::DS28;

use constant TRUE => 1;
use constant FALSE => undef;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);


#--- !!!!!!!!!!!! Just a hust to be replaced

sub init
{
	my $self = shift;

	$self->{type} = 'asn1'; # csv fixedwidth asn1
	#$self->{has_header} = TRUE;
	#$self->{skip_header_lines} = 1;
	#$self->{header_regex} = qr/^$/;
	$self->{trim_values} = TRUE;
	#$self->{has_trailer} = TRUE;
	#$self->{trailer_regex} = qr/^$/;
  $self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
  $self->{data_factor} = 1; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{name => 'recordType'},
		{
			name => 'GenericDigits',
			decode => 'decodeRevenue'
		},
		{name => 'GenericNumber'},
		{name => 'acceptanceOfCallWaiting'},
		{name => 'asyncSyncIndicator'},
		{name => 'bSSMAPCauseCode'},
		{name => 'bearerServiceCode'},
		{name => 'callIdentificationNumber'},
		{name => 'callPosition'},
		{name => 'calledPartyMNPInfo'},
		{
			name => 'calledPartyNumber',
			decode => 'decodeDigitPairs'
		},
		{
			name => 'calledSubscriberIMEI',
			decode => 'decodeDigitPairs'
		},
		{
			name => 'calledSubscriberIMEISV',
			decode => 'decodeDigitPairs'
		},
		{
			name => 'calledSubscriberIMSI',
			decode => 'decodeIMSI'
		},
		{
			name => 'callingPartyNumber',
			decode => 'decodeDigitPairs'
		},
		{
			name => 'callingSubscriberIMEI',
			decode => 'decodeDigitPairs'
		},
		{
			name => 'callingSubscriberIMEISV',
			decode => 'decodeDigitPairs'
		},
		{
			name => 'callingSubscriberIMSI',
			decode => 'decodeIMSI'
		},
		{name => 'chargeNumber'},
		{name => 'chargePartySingle'},
		{
			name => 'chargeableDuration',
			decode => 'decodeDuration'
		},
		{name => 'chargedParty'},
		{name => 'chargingCase'},
		{name => 'dTMFUsed'},
		{
			name => 'dateForStartOfCharge',
			decode => 'decode3TupleDate'
		},
		{name => 'defaultCallHandling'},
		{name => 'deliveryOfErroneousSDU1'},
		{name => 'deliveryOfErroneousSDU2'},
		{name => 'deliveryOfErroneousSDU3'},
		{name => 'destinationAddress'},
		{name => 'disconnectingParty'},
		{name => 'eMLPPPriorityLevel'},
		{name => 'eosInfo'},
		{name => 'exchangeIdentity'},
		{name => 'fNURRequested'},
		{name => 'faultCode'},
		{name => 'firstAssignedSpeechCoderVersion'},
		{name => 'firstCalledLocationInformation'},
		{name => 'firstCallingLocationInformation'},
		{name => 'firstRadioChannelUsed'},
		{name => 'frequencyBandSupported'},
		{name => 'gSMCallReferenceNumber'},
		{name => 'globalTitleAndSubSystemNumber'},
		{name => 'gsmSCFAddress'},
		{name => 'guaranteedBitRate'},
		{name => 'iCIOrdered'},
		{name => 'iNMarkingOfMS'},
		{name => 'iNServiceTrigger'},
		{name => 'incomingAssignedRoute'},
		{name => 'incomingRoute'},
		{name => 'intermediateRate'},
		{name => 'internalCauseAndLoc'},
		{
			name => 'interruptionTime',
			decode => 'decode3TupleTime'
		},
		{name => 'invocationOfCallHold'},
		{name => 'lastCalledLocationInformation'},
		{name => 'lastCallingLocationInformation'},
		{name => 'levelOfCAMELService'},
		{
			name => 'mSCAddress',
			decode => 'decodeDigitPairs'
		},
		{
			name => 'mSCIdentification',
			decode => 'decodeDigitPairs'
		},
		{name => 'maxBitRateDownlink'},
		{name => 'maxBitRateUplink'},
		{name => 'messageReference'},
		{name => 'messageTypeIndicator'},
		{
			name => 'mobileStationRoamingNumber',
			decode => 'decodeDigitPairs'
		},
		{name => 'multimediaCall'},
		{name => 'networkCallReference'},
		{name => 'numberOfShortMessages'},
		{name => 'originForCharging'},
		{name => 'originalCalledNumber'},
		{name => 'originatedCode'},
		{
			name => 'originatingAddress',
			decode => 'decodeDigitPairs'
		},
		{name => 'originatingLineInformation'},
		{name => 'originatingLocationNumber'},
		{name => 'outgoingAssignedRoute'},
		{name => 'outgoingRoute'},
		{name => 'outputForSubscriber'},
		{name => 'outputType'},
		{name => 'pointCodeAndSubSystemNumber'},
		{name => 'presentationAndScreeningIndicator'},
		{name => 'rANAPCauseCode'},
		{name => 'rNCidOfFirstRNC'},
		{name => 'radioChannelProperty'},
		{name => 'recordSequenceNumber'},
		{
			name => 'redirectingIMSI',
			decode => 'decodeIMSI'
		},
		{name => 'redirectingNumber'},
		{name => 'redirectionCounter'},
		{name => 'relatedCallNumber'},
		{name => 'reroutingIndicator'},
		{name => 'residualBitErrorRatio1'},
		{name => 'residualBitErrorRatio2'},
		{name => 'residualBitErrorRatio3'},
		{name => 'retrievalOfHeldCall'},
		{name => 'sDUErrorRatio1'},
		{name => 'sDUErrorRatio2'},
		{name => 'sDUErrorRatio3'},
		{name => 'sSFChargingCase'},
		{name => 'sSFLegID'},
		{
			name => 'serviceCentreAddress',
			decode => 'decodeDigitPairs'
		},
		{name => 'serviceFeatureCode'},
		{name => 'serviceKey'},
		{name => 'speechCoderPreferenceList'},
		{name => 'subscriptionType'},
		{name => 'switchIdentity'},
		{name => 'tAC'},
		{name => 'targetLocationInformation'},
		{name => 'tariffClass'},
		{name => 'tariffSwitchInd'},
		{name => 'teleServiceCode'},
		{
			name => 'terminatingLocationNumber',
			decode => 'decodeDigitPairs'
		},
		{
			name => 'timeForEvent',
			decode => 'decode3TupleTime'
		},
		{
			name => 'timeForStartOfCharge',
			decode => 'decode3TupleTime'
		},
		{
			name => 'timeForStopOfCharge',
			decode => 'decode3TupleTime'
		},
		{
			name => 'timeForTCSeizureCalled',
			decode => 'decode3TupleTime'
		},
		{
			name => 'timeForTCSeizureCalling',
			decode => 'decode3TupleTime'
		},
		{
			name => 'timeFromRegisterSeizureToStartOfCharging',
			decode => 'decode3TupleTime'
		},
		{name => 'trafficClass'},
		{name => 'transferDelay'},
		{
			name => 'translatedNumber',
			decode => 'decodeDigitPairs'
		},
		{name => 'transparencyIndicator'},
		{name => 'triggerDetectionPoint'},
		{name => 'typeOfCallingSubscriber'},
		{name => 'uILayer1Protocol'},
		{name => 'userRate'}
	];

	$self->{format} = $format;
}

=top
#saving this in a comment
	my $format = 
	[
		{name => 'recordType'},
		{name => '1stAssignedSpeechCoderVer'},
		{name => 'acceptanceOfCallWaiting'},
		{name => 'asynSyncIndicator'},
		{name => 'bSSMAPCauseCode'},
		{name => 'callIdentificationNumber'},
		{name => 'callPosition'},
		{name => 'calledPartyMNPInfo'},
		{name => 'calledPartyNumber'},
		{name => 'calledSubscriberIMEI'},
		{name => 'calledSubscriberIMEIS'},
		{name => 'calledSubscriberIMEISV'},
		{name => 'calledSubscriberIMSI'},
		{name => 'callingPartyNumber'},
		{name => 'callingSubscriberIMEI'},
		{name => 'callingSubscriberIMEISV'},
		{name => 'callingSubscriberIMSI'},
		{name => 'cellIDFor1stCellCalled'},
		{name => 'cellIDFor1stCellCalling'},
		{name => 'cellIDForLastCellCalled'},
		{name => 'cellIDForLastCellCalling'},
		{name => 'cellIDOfLastCellCalled'},
		{name => 'chargeNumber'},
		{name => 'chargeableDuration'},
		{name => 'chargedParty'},
		{name => 'chargingCase'},
		{name => 'dTMFUsed'},
		{name => 'dateForStartofCharge'},
		{name => 'defaultCallHandling'},
		{name => 'deliveryOfErroneousSDU1'},
		{name => 'deliveryOfErroneousSDU2'},
		{name => 'deliveryOfErroneousSDU3'},
		{name => 'destinationAddress'},
		{name => 'disconnectingParty'},
		{name => 'eMLPPPriorityLevel'},
		{name => 'eosInfo'},
		{name => 'exchangeIdentity'},
		{name => 'fNURRequested'},
		{name => 'faultCode'},
		{name => 'firstRadioChannelUsed'},
		{name => 'frequencyBandSupported'},
		{name => 'gSMBearerServiceCode'},
		{name => 'gSMCallRefNum'},
		{name => 'gSMCallReferenceNumber'},
		{name => 'gSMSCFAddress1'},
		{name => 'teleServiceCode'},
		{name => 'GenericDigits'},
		{name => 'GenericNumber'},
		{name => 'guaranteedBitRate'},
		{name => 'iCIOrdered'},
		{name => 'iNMarkingOfMS'},
		{name => 'iNSDSSFLegID'},
		{name => 'iNSDataChargePartySingle'},
		{name => 'iNSDataServiceFeatureCode'},
		{name => 'iNSDatasSFLegID'},
		{name => 'iNSDatatimeForEvent'},
		{name => 'iNServiceTrigger'},
		{name => 'incomingAssignedRoute'},
		{name => 'incomingRoute'},
		{name => 'intermediateRate'},
		{name => 'internalCauseAndLoc'},
		{name => 'interruptionTime'},
		{name => 'invocationOfCallHold'},
		{name => 'levelOfCAMELService'},
		{name => 'mSCAddress'},
		{name => 'mSCIdentification'},
		{name => 'maxBitrateDownlink'},
		{name => 'maxBitrateUplink'},
		{name => 'messageReference'},
		{name => 'messageTypeIndicator'},
		{name => 'mobileStationRoamingNum'},
		{name => 'multimediaCall'},
		{name => 'networkCallRef'},
		{name => 'networkCallReference'},
		{name => 'numberOfShortMessages'},
		{name => 'originForCharging'},
		{name => 'originLineInfo'},
		{name => 'originalCalledNumber'},
		{name => 'originatedCode'},
		{name => 'originatingAddress'},
		{name => 'originatingLocationNumber'},
		{name => 'outgoingAssignedRoute'},
		{name => 'outgoingRoute'},
		{name => 'outputForSubscriber'},
		{name => 'outputType'},
		{name => 'presAndScreenInd'},
		{name => 'rNCIdofFirstRNC'},
		{name => 'radioChannelProperty'},
		{name => 'ranapCauseCode'},
		{name => 'recordSequenceNumber'},
		{name => 'redirectingIMSI'},
		{name => 'redirectingNumber'},
		{name => 'redirectionCounter'},
		{name => 'relatedCallNumber'},
		{name => 'reroutingIndicator'},
		{name => 'residualBitErrorRatio1'},
		{name => 'residualBitErrorRatio2'},
		{name => 'residualBitErrorRatio3'},
		{name => 'retrievalOfHeldCall'},
		{name => 'sCPAddress2'},
		{name => 'sCPAddress4'},
		{name => 'sDUErrorRatio1'},
		{name => 'sDUErrorRatio2'},
		{name => 'sDUErrorRatio3'},
		{name => 'sSFChargingCase'},
		{name => 'serviceCentreAddress'},
		{name => 'serviceKey'},
		{name => 'serviceKey1'},
		{name => 'speechCoderPrefList'},
		{name => 'subsType'},
		{name => 'subscriptionType'},
		{name => 'switchIdentity'},
		{name => 'tAC'},
		{name => 'targetLocationInformation'},
		{name => 'tariffClass'},
		{name => 'tariffSwitchInd'},
		{name => 'terminatingLocationNumber'},
		{name => 'timeForEvent'},
		{name => 'timeForStartofCharge'},
		{name => 'timeForStopofCharge'},
		{name => 'timeForTCseizureCalled'},
		{name => 'timeForTCseizureCalling'},
		{name => 'timeFromRegSeizuToStofChg'},
		{name => 'trafficClass'},
		{name => 'transferDelay'},
		{name => 'translatedNum'},
		{name => 'translatedNumber'},
		{name => 'transparencyIndicator'},
		{name => 'trigDetPoint'},
		{name => 'typeOfCallingSubscriber'},
		{name => 'uILayer1Protocol'},
		{name => 'userRate'},
	];

=cut

1;
