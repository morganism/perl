package Ascertain::UM::VFI::Aggregator::DS28;

#------------------------------------------------------------------------------
# This is for contructing this as a subclass of Aggregator
#------------------------------------------------------------------------------
use Data::Dumper;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Aggregator);
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# This is the DS specific 'aggregate' method called by Aggregator->aggregate()
#------------------------------------------------------------------------------

use constant TRUE => 1;
use constant FALSE => 0;
use constant UNKNOWN => "UNKNOWN";


sub _aggregate
{
	my $self = shift;
	my $args = shift;

	my $d = $args->{record};

  #-- reset the indicators
  #-- the parent class Aggregator.pm defines available AUTOLOADed terms
  $self->resetAttributes();

  #-- set the vars used as keys and counters when aggregating
  #-- the parent class Aggregator.pm defines available AUTOLOADed terms
	my $timeSlot = "1999011401";
	$self->D_TIMESLOT($timeSlot);          #AGGREGATOR KEY
	$self->D_USAGE_TYPE(UNKNOWN);        #AGGREGATOR KEY
	$self->D_SERVICE_TYPE(UNKNOWN);      #AGGREGATOR KEY
  #--- EVERYTHING ABOVE IS REQUIRED
	my $ST_ALL = FALSE;
	my $ST_VOICE = FALSE;
	my $ST_VOICE_POSTPAID = FALSE;
	my $ST_VOICE_POSTPAID_HOME = FALSE;
	my $ST_VOICE_POSTPAID_HOME_MO = FALSE;
	my $ST_VOICE_POSTPAID_HOME_MO_FREE = FALSE;
	my $ST_VOICE_POSTPAID_HOME_CALL_FWD = FALSE;
	my $ST_VOICE_PREPAID = FALSE;
	my $ST_VOICE_PREPAID_HOME = FALSE;
	my $ST_VOICE_PREPAID_HOME_MO = FALSE;
	my $ST_VOICE_PREPAID_HOME_CALL_FWD = FALSE;
	my $ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MT = FALSE;
	my $ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MT = FALSE;
    my $ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MT_ARP = FALSE;
    my $ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MT_ARP = FALSE;
	my $ST_VOICE_INBOUND_ROAMERS_MO = FALSE;
	my $ST_VOICE_INBOUND_ROAMERS_MT = FALSE;
	my $ST_VOICE_INTERCONNECT = FALSE;
	my $ST_SMS = FALSE;
	my $ST_SMS_HOME = FALSE;
	my $ST_SMS_HOME_MO = FALSE;
	my $ST_SMS_HOME_MT = FALSE;
	my $ST_SMS_VODAFONE = FALSE;
	my $ST_SMS_O2 = FALSE;
	my $ST_SMS_METEOR = FALSE;
	my $ST_SMS_HUTCHINSON = FALSE;
	my $ST_SMS_TESCO = FALSE;
	my $ST_SMS_POSTFONE = FALSE;
	my $ST_SMS_JUSTMOBILE = FALSE;
	my $ST_SMS_OTHER_DEST = FALSE;
	my $ST_SMS_PREMIUM = FALSE;
	my $ST_SMS_PREPAID = FALSE;
	my $ST_SMS_OTHER_INBOUND_ROAMERS_MO = FALSE;
	my $ST_SMS_OTHER_INBOUND_ROAMERS_MT = FALSE;
	my $ST_SMS_OTHER_OUTBOUND_ROAMERS_MO = FALSE;
	my $ST_SMS_OTHER_OUTBOUND_ROAMERS_MT = FALSE;
	my $ST_SMS_ROAMING_MO_PREPAID = FALSE;
	my $ST_SMS_PREMIUM_MO_PREPAID = FALSE;
	my $ST_SMS_PREMIUM_MT_PREPAID = FALSE;
	my $ST_MMS = FALSE;
	my $ST_MMS_POSTPAID = FALSE;
	my $ST_MMS_POSTPAID_HOME = FALSE;
	my $ST_MMS_POSTPAID_HOME_MO = FALSE;
	my $ST_MMS_PREPAID = FALSE;
	my $ST_MMS_PREPAID_HOME = FALSE;
	my $ST_MMS_PREPAID_HOME_MO = FALSE;
	my $ST_MMS_OTHER = FALSE;
	my $ST_DATA_GPRS = FALSE;
	my $ST_DATA_WAP = FALSE;
	my $ST_DATA_GPRS_PREPAID = FALSE;
	my $ST_DATA_GPRS_POSTPAID = FALSE;
	my $ST_DATA_WAP_PREPAID = FALSE;
	my $ST_DATA_WAP_POSTPAID = FALSE;
	my $ST_DATA_GPRS_PREPAID_STRIP = FALSE;
	my $ST_DATA_GPRS_POSTPAID_STRIP = FALSE;
	my $ST_DATA_WAP_PREPAID_STRIP = FALSE;
	my $ST_DATA_WAP_POSTPAID_STRIP = FALSE;
	my $ST_CONTENT_POSTPAID = FALSE;
	my $ST_CONTENT_PREPAID = FALSE;

	my $ST_ITC_SMS_IN = FALSE;
	my $ST_ITC_VOICE = FALSE;
	my $ST_ITC_VOICE_IN = FALSE;
	my $ST_ITC_VOICE_OUT = FALSE;

    my $ST_VOICE_PARTNERS = FALSE;
    my $ST_DATA_PARTNERS = FALSE;


	my $ST_UNIDENT = TRUE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";
	
	$self->specifySourceInit();

	#----------------- RECORD TYPE --------------------
	my $recordType = $d->{recordType};
	#----------------- RECORD TYPE --------------------
	if (not defined $recordType)
	{
		$self->{input_file_obj}->decrementAggregatedLineCount();
		return undef;
	}


	#----------------- USAGE TYPE --------------------
	my $usageType;
	if ($recordType eq "mSOriginatingSMSinMSC" or $recordType eq "mSTerminatingSMSinMSC")
	{
		$usageType = "SMS";
		$self->D_USAGE_TYPE($usageType);
		$ST_SMS = TRUE; push @serviceTypes, "ST_SMS";
		$ST_UNIDENT = FALSE;
	}
	else
	{
		$usageType = "VOICE";
		$self->D_USAGE_TYPE($usageType);
		$ST_VOICE = TRUE; push @serviceTypes, "ST_VOICE";
		$ST_UNIDENT = FALSE;
	}
	#----------------- USAGE TYPE --------------------


	#----------------- TIMESLOT --------------------
	if ((defined $d->{dateForStartOfCharge}) and (defined $d->{timeForStartOfCharge}))
	{
		# recordType eq iNIncomingCall does not define a date
		
		$timeSlot = $self->getTimeslot($d->{dateForStartOfCharge}, $d->{timeForStartOfCharge});
		$self->D_TIMESLOT($timeSlot) if (defined $timeSlot);
	}
	else
	{
		 $self->{timeslotError}{$recordType}++;
		 $self->{unaggregateable}++;	 
		 return undef;
	}
	#----------------- TIMESLOT --------------------


	#----------------- SERVICE TYPE --------------------
	# these fields need decoding, so we'll do that once right here
	my $callingSubscriberIMSI = $self->decodeIMSI($d->{callingSubscriberIMSI});
	$self->IMSI($callingSubscriberIMSI); # for ONXP
	my $calledSubscriberIMSI  = $self->decodeIMSI($d->{calledSubscriberIMSI});
	my $redirectingIMSI       = $self->decodeIMSI($d->{redirectingIMSI});
    my $calledPartyNumber     = $self->decodeDigitPairs($d->{calledPartyNumber});

	if ($ST_SMS)
	{

		#ST_SMS_OTHER_HOME 
		#and recordType = MS_ORIG_SMS_IN_MSC 
		#and callingSubscriberIMSI beings with 27201 but not an MVNO IMSI
		#ST_SMS_OTHER_HOME 
		#and recordType = MS_TERM_SMS_IN_MSC 
		#and calledSubscriberIMSI beings with 27201 but not an MVNO IMSI
		# doing this backwards to the biz rules - makes more sense
		if ($recordType eq "mSOriginatingSMSinMSC")
		{
			if ($callingSubscriberIMSI =~ /^27201[^1]/)
			{
				$ST_SMS_HOME_MO = TRUE; push @serviceTypes, "ST_SMS_HOME_MO";
				if ($d->{typeOfCallingSubscriber} eq "07")
				{
					$ST_SMS_PREPAID = TRUE; push @serviceTypes, "ST_SMS_PREPAID"; # apparently the same rule
				}
			}
			# not VFI but ok if MVNO
			elsif
			(
        ($callingSubscriberIMSI !~ /^27201/) or
        ($callingSubscriberIMSI =~ /^27201[1]/)
			)
			{
				$ST_SMS_OTHER_INBOUND_ROAMERS_MO = TRUE; push @serviceTypes, "ST_SMS_OTHER_INBOUND_ROAMERS_MO";
			}
		}
		elsif ($recordType eq "mSTerminatingSMSinMSC")
		{
			if ($calledSubscriberIMSI =~ /^27201[^1]/)
			{
				$ST_SMS_HOME_MT = TRUE; push @serviceTypes, "ST_SMS_HOME_MT";
			}
			# not VFI but ok if MVNO
			elsif
			(
        ($calledSubscriberIMSI !~ /^27201/) or
        ($calledSubscriberIMSI =~ /^27201[1]/)
			)
			{
				$ST_SMS_OTHER_INBOUND_ROAMERS_MT = TRUE; push @serviceTypes, "ST_SMS_OTHER_INBOUND_ROAMERS_MT";
			}
		}

		# -- see rule above
		#ST_SMS_OTHER 
		#and ( (recordType = MS_ORIG_SMS_IN_MSC 
		#and callingSubscriberIMSI beings with 27201 but not an MVNO IMSI) 
		#or ( recordType = MS_TERM_SMS_IN_MSC 
		#and calledSubscriberIMSI beings with 27201 but not an MVNO IMSI) )
		if ($ST_SMS_HOME_MO or $ST_SMS_HOME_MT)
		{
			$ST_SMS_HOME = TRUE; push @serviceTypes, "ST_SMS_HOME";
		}
	}
	elsif($ST_VOICE)
	{

		# ------------- !!! This appears in a different order than in the BIZ RULES DOC
		# !!!! This code snippet is used for both POST and PRE (the next line is obviously different)
		# ------------- !!!
		#ST_VOICE_POSTPAID and 
		#((recordType=CALL_FORWARDING 
		#and redirectingIMSI beings with 27201 but not an MVNO IMSI) 
		#or (recordType=MS_ORIGINATING 
		#and callingSubscriberIMSI beings with 27201 but not an MVNO IMSI) 
		#or (recordType=MS_TERMINATING 
		#and calledSubscriberIMSI beings with 27201 but not an MVNO IMSI))
		# HOME non MVNO IMSI check == must begin with ^27201 but not ^272011 MVNO
		my $ST_HOME_FLAG = FALSE;
		my $ST_HOME_MO_FLAG = FALSE;
		my $ST_HOME_CALL_FWD_FLAG = FALSE;
		if 
		(
			(($recordType eq "callForwarding") and ($redirectingIMSI       =~ /^27201[^1]/)) or
			(($recordType eq "mSOriginating")  and ($callingSubscriberIMSI =~ /^27201[^1]/)) or
			(($recordType eq "mSTerminating")  and ($calledSubscriberIMSI  =~ /^27201[^1]/))
		)
		{
			$ST_HOME_FLAG = TRUE;

			# !!!! This code snippet is used for both POST and PRE (the next line is obviously different)
			#ST_VOICE_POSTPAID_HOME 
			#and (recordType=MS_ORIGINATING 
			#and callingSubscriberIMSI beings with 27201 but not an MVNO IMSI 
			#and teleServiceCode != 12 
			#and teleServiceCode is not null) or recordType = GSM2_ISDN_ORIG         <-- Or added 31-May-2011
			if
			(
				($recordType eq "mSOriginating") and 
				($callingSubscriberIMSI =~ /^27201[^1]/) and
				(defined $d->{teleServiceCode}) and
				($d->{teleServiceCode} ne "12")
			)
			{
				$ST_HOME_MO_FLAG = TRUE;
			}

			# !!!! This code snippet is used for both POST and PRE (the next line is obviously different)
			#ST_VOICE_POSTPAID_HOME 
			#and INMarkingofMS != "" 
			#and RedirectingIMSI beings with 27201 but not an MVNO IMSI
			if (defined $d->{iNMarkingOfMS} and ($redirectingIMSI =~ /^27201[^1]/))
			{
				$ST_HOME_CALL_FWD_FLAG = TRUE;
			}
		}


		#ST_VOICE 
		#and isICIOrdered
		if (exists $d->{iCIOrdered})
		{
			$ST_VOICE_PREPAID = TRUE; push @serviceTypes, "ST_VOICE_PREPAID";

			if ($ST_HOME_FLAG)
			{
				$ST_VOICE_PREPAID_HOME = TRUE; push @serviceTypes, "ST_VOICE_PREPAID_HOME";

				if ($ST_HOME_MO_FLAG)
				{
					$ST_VOICE_PREPAID_HOME_MO = TRUE; push @serviceTypes, "ST_VOICE_PREPAID_HOME_MO";
				}

				if ($ST_HOME_CALL_FWD_FLAG)
				{
					$ST_VOICE_PREPAID_HOME_CALL_FWD = TRUE; push @serviceTypes, "ST_VOICE_PREPAID_HOME_CALL_FWD";
				}
			}

			# Prepaid Roaming MT
			if (    ($recordType eq "roamingCallForwarding") 
				and ($calledSubscriberIMSI  =~ /^27201[^1]/)
			    )
		    {
				if ($calledPartyNumber =~ /^..555.*/) {
					$ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MT_ARP = TRUE; push (@serviceTypes, "ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MT_ARP");
				}
				else {
					$ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MT = TRUE; push (@serviceTypes, "ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MT");
				}
			}
		}
		#ST_VOICE 
		#and not isICIOrdered
		else
		{
			# ONXP 
			my $isOnxp = $self->isOnxpImsi();
			$ST_VOICE_POSTPAID = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID";
			push @serviceTypes, "ST_ONXP_VOICE_POSTPAID" if ($isOnxp);

			my $translatedNumber =  $self->decodeDigitPairs($d->{translatedNumber});
			my $dialledDigit = substr $translatedNumber, 2; 

			if ($ST_HOME_FLAG)
			{
				$ST_VOICE_POSTPAID_HOME = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME";
				push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME" if ($isOnxp);

				if ($ST_HOME_MO_FLAG)
				{
					if ($self->isICCSFreeNumber( $dialledDigit )) # dialled digit not in Free of charge number list
                                	{
                                        	$ST_VOICE_POSTPAID_HOME_MO_FREE = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME_MO_FREE";
                                	}
                                	else {
                                        	$ST_VOICE_POSTPAID_HOME_MO = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME_MO";
                                        	push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME_MO" if ($isOnxp);
                                	}

				}

				if ($ST_HOME_CALL_FWD_FLAG)
				{
					$ST_VOICE_POSTPAID_HOME_CALL_FWD = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME_CALL_FWD";
					push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME_CALL_FWD" if ($isOnxp);
				}
			}
			# ST_VOICE_POSTPAID_HOME_MO Rule extended by David Costigan 31-May-2011
			if (($recordType eq "iSDNOriginating") and ($ST_VOICE_POSTPAID_HOME_MO ne TRUE)) 
			{
				if ($self->isICCSFreeNumber(  $dialledDigit ) ) # dialled digit not in Free of charge number list
                                {
 	                               $ST_VOICE_POSTPAID_HOME_MO_FREE = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME_MO_FREE";
                                }
                                else {
                                       $ST_VOICE_POSTPAID_HOME_MO = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME_MO";
                                       push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME_MO" if ($isOnxp);
                                }
			}

            # Postpaid Roaming MT
            if (    ($recordType eq "roamingCallForwarding")
                and ($calledSubscriberIMSI  =~ /^27201[^1]/)
                )
            {
                if ($calledPartyNumber =~ /^..555.*/) {
                    $ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MT_ARP = TRUE; push (@serviceTypes, "ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MT_ARP");
                }
                else {
                    $ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MT = TRUE; push (@serviceTypes, "ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MT");
                }
            }

		}


	        #ST_VOICE
                #and recordType=MS_ORIGINATING
                #and callingSubscriberIMSI not beings with 27201 except an MVNO IMSI
                #and teleServiceCode != 12
                if
                (
                        (
                                # not VFI but ok if MVNO
                                ($callingSubscriberIMSI !~ /^27201/) or
                                ($callingSubscriberIMSI =~ /^27201[1]/)
                        )
                        and ($d->{teleServiceCode} ne "12")
                        and ($recordType eq "mSOriginating")
                )
                {
                        $ST_VOICE_INBOUND_ROAMERS_MO = TRUE; push @serviceTypes, "ST_VOICE_INBOUND_ROAMERS_MO";
                }

                #and recordType=MS_TERMINATING_
                #and calledSubscriberIMSI not beings with 27201 except an MVNO IMSI
                #and teleServiceCode != 12
                if
                (
                        (
                                # not VFI but ok if MVNO
                                ($calledSubscriberIMSI !~ /^27201/) or
                                ($calledSubscriberIMSI =~ /^27201[1]/)
                        )
                        and ($d->{teleServiceCode} ne "12")
                        and ($recordType eq "mSTerminating")
                )
                {
                        $ST_VOICE_INBOUND_ROAMERS_MT = TRUE; push @serviceTypes, "ST_VOICE_INBOUND_ROAMERS_MT";
                }
	}

	my $serviceCentreAddress = (defined $d->{serviceCentreAddress}) ? $self->decodeDigitPairs($d->{serviceCentreAddress}) : "";


	# INTERCONNECT Service Types

	# SMS Interconnect
	if (     $recordType eq "mSTerminatingSMSinMSC" 
#	     and ( defined $d->{incomingRoute} or defined $d->{outgoingRoute} )
             and not (  $self->isItcExcServiceCentreValue($calledSubscriberIMSI,$serviceCentreAddress) )
 	    )
	{
		$ST_ITC_SMS_IN = TRUE; push (@serviceTypes, "ST_ITC_SMS_IN");
	}

    
	
    # Voice Interconnect
    if (     $recordType ne "mSTerminating"
         and $recordType ne "ISDNOriginating"
         and $recordType ne "mSOriginatingSMSinMSC"
         and $recordType ne "mSTerminatingSMSinMSC"
         and not ( defined $d->{partialOutputRecNum} and not defined $d->{lastPartialOutput} )
        )
    {

        my $translatedNumber = (defined $d->{translatedNumber}) ? $self->decodeDigitPairs($d->{translatedNumber}) : "";
        my $routeMatchType = $self->isItcRouteValue($d->{incomingRoute},$d->{outgoingRoute});


        if ( not ( $d->{outgoingRoute} eq "VMSGRI" and $translatedNumber =~ /^113538.5/ )) {

           if ( $routeMatchType eq "OMATCH" )  {
                $ST_ITC_VOICE_OUT = TRUE; push (@serviceTypes, "ST_ITC_VOICE_OUT");
                $ST_ITC_VOICE = TRUE; push (@servicetypes, "ST_ITC_VOICE");
            }
            elsif ( $routeMatchType eq "IMATCH" and $recordType ne "callForwarding" and $recordType ne "roamingCallForwarding" )
        	{
                $ST_ITC_VOICE_IN = TRUE; push (@serviceTypes, "ST_ITC_VOICE_IN");
                $ST_ITC_VOICE = TRUE; push (@servicetypes, "ST_ITC_VOICE");
            }
            elsif ( $routeMatchType eq "FMATCH" or ($routeMatchType eq "IMATCH" and ( $recordType eq "callForwarding" or $recordType eq "roamingCallForwarding" ))) {
		        if ( defined $d->{tariffClass} and
     			     ( $d->{tariffClass} eq "00 01" or $d->{tariffClass} eq "00 03" )
			     and not ( $recordType eq "callForwarding" and $d->{outgoingRoute} eq "SSFDJO" ) ) {
						
  			            $ST_ITC_VOICE_OUT = TRUE; push (@serviceTypes, "ST_ITC_VOICE_OUT");
		    		    $ST_ITC_VOICE = TRUE; push (@servicetypes, "ST_ITC_VOICE");

           		}
        		elsif ( defined $d->{tariffClass} and $d->{tariffClass} eq "00 02" ) {
 
			            $ST_ITC_VOICE_IN = TRUE; push (@serviceTypes, "ST_ITC_VOICE_IN");
				        $ST_ITC_VOICE = TRUE; push (@servicetypes, "ST_ITC_VOICE");
        		}
            }
	    }

    }

	# MVNO/WHolesale Partner & Bundle service types
	if ($ST_VOICE) {
		my $imsiLookup = "";
		my $translatedNumber = (defined $d->{translatedNumber}) ? $self->decodeDigitPairs($d->{translatedNumber}) : "";

		if ($recordType eq "callForwarding") { $imsiLookup = $redirectingIMSI; }
		if ($recordType eq "mSOriginating") { $imsiLookup = $callingSubscriberIMSI; }
		if ($recordType eq "mSTerminating") { $imsiLookup =  $calledSubscriberIMSI; }

        if (		  $self->isPartner($imsiLookup) ne 0 
#			and not ( $recordType eq "callForwarding" and $d->{iNServiceTrigger} eq "00 71" )
#			and not ( $translatedNumber eq "121747" ) 
	   )    	
		{
            $ST_VOICE_PARTNERS = TRUE; push @serviceTypes, "ST_VOICE_PARTNERS";
			$self->specifySourceForAggRecords("ST_VOICE_PARTNERS",$self->isPartner($imsiLookup));
        }
	}


	#----------------- SERVICE TYPE --------------------
	

	my $duration = (defined $d->{chargeableDuration}) ? $self->decodeDuration($d->{chargeableDuration}) : 0;

	# only applies to PREPAID
	my $revenue = 0;
	if ($ST_SMS_PREPAID or $ST_VOICE_PREPAID)
	{
		$revenue = (defined $d->{GenericDigits}->[4]) ? $self->decodeRevenue($d->{GenericDigits}->[4]) : "0";
	}
	

	# ---- FILL AGGREGATION DATA STRUCTURE
	push @serviceTypes, "ST_UNIDENT" if ($ST_UNIDENT); 
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => $duration,
			sum_bytes    => 0,
			sum_value    => $revenue
		}
	); # call the method in the parent class

	# ---- FILL AGGREGATION DATA STRUCTURE
}
#------------------------------------------------------------------------------


# convert dateForStartOfCharge + timeForStartOfCharge to a YYYYMMDDHH24 format
sub getTimeslot
{
        my $self = shift;
        my ($d, $t) = @_;
        my @pairs = split / /, "20" . $self->decodeHexPairs($d) . " " . $self->decodeHexPairs($t);
        my $ts = sprintf "%4d%02d%02d%02d%02d%02d", @pairs;

        return $ts if ($ts =~ s/^(\d{10}).*/$1/); # parse success
        return FALSE; # parse failed
}


1;
