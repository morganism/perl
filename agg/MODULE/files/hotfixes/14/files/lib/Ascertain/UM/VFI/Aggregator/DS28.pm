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
	my $ST_VOICE_POSTPAID_HOME_CALL_FWD = FALSE;
	my $ST_VOICE_PREPAID = FALSE;
	my $ST_VOICE_PREPAID_HOME = FALSE;
	my $ST_VOICE_PREPAID_HOME_MO = FALSE;
	my $ST_VOICE_PREPAID_HOME_CALL_FWD = FALSE;
	my $ST_VOICE_OUTBOUND_ROAMERS_MO = FALSE;
	my $ST_VOICE_OUTBOUND_ROAMERS_MT = FALSE;
	my $ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MO = FALSE;
	my $ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MT = FALSE;
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
	my $ST_UNIDENT = TRUE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";
	
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
		}
		#ST_VOICE 
		#and not isICIOrdered
		else
		{
			# ONXP 
			my $isOnxp = $self->isOnxpImsi();
			$ST_VOICE_POSTPAID = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID";
			push @serviceTypes, "ST_ONXP_VOICE_POSTPAID" if ($isOnxp);
			if ($ST_HOME_FLAG)
			{
				$ST_VOICE_POSTPAID_HOME = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME";
				push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME" if ($isOnxp);

				if ($ST_HOME_MO_FLAG)
				{
					$ST_VOICE_POSTPAID_HOME_MO = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME_MO";
					push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME_MO" if ($isOnxp);
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
				$ST_VOICE_POSTPAID_HOME_MO = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME_MO";
				push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME_MO" if ($isOnxp);
			}
		}

		#ST_VOICE
		#and recordType=MS_ORIGINATING 
		#and callingSubscriberIMSI not beings with 27201 except an MVNO IMSI 
		#and teleServiceCode != 12 
		#and teleServiceCode is not null
		if 
		(
			(
				# not VFI but ok if MVNO
				($callingSubscriberIMSI !~ /^27201/) or 
				($callingSubscriberIMSI =~ /^27201[1]/) 
			) and
			(defined $d->{teleServiceCode}) and
			($d->{teleServiceCode} ne "12")
		)
		{
			if ($recordType eq "mSOriginating")
			{
				$ST_VOICE_INBOUND_ROAMERS_MO = TRUE; push @serviceTypes, "ST_VOICE_INBOUND_ROAMERS_MO";
			}
			elsif ($recordType eq "mSTerminating")
			{
				$ST_VOICE_INBOUND_ROAMERS_MT = TRUE; push @serviceTypes, "ST_VOICE_INBOUND_ROAMERS_MT";
			}
		}

#"Business rule = ""ST_VOICE
#and recordType=MS_ORIGINATING 
#and callingSubscriberIMSI beings with 27201 except an MVNO IMSI 
#and teleServiceCode != 12 
#and teleServiceCode is not null and generic charging digit 0 == '3'"""

		if 
		(
			(defined $d->{recordType} and $d->{recordType} eq "mSOriginating") and
			($callingSubscriberIMSI =~ /^27201[^1]/) and
			(defined $d->{teleServiceCode} and $d->{teleServiceCode} ne "12")
		)
		{
			if (defined $d->{GenericDigits}->[0])
			{
				if ($d->{GenericDigits}->[0] eq "20 03")
				{
					$ST_VOICE_OUTBOUND_ROAMERS_MO = TRUE; push (@servicetypes, "ST_VOICE_OUTBOUND_ROAMERS_MO");
				}
				elsif ($d->{GenericDigits}->[0] eq "20 05")
				{
					$ST_VOICE_OUTBOUND_ROAMERS_MT = TRUE; push (@servicetypes, "ST_VOICE_OUTBOUND_ROAMERS_MT");
				}
			}
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

# this will take a list of pairs in hex and return decimal pairs 
# 10 11 10 => 16 17 16 
# dates and times are stored like this
sub decodeHexPairs
{
	my $self = shift;
	my $pairString = shift;
	return join " ", map {hex $_} split /\s+/, $pairString;
}
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


# the encoded representation below
#72 02 71 10 70 08 39 F4
# should read : 272017010780934
# note the 'F' as padding
sub decodeIMSI
{
	my $self = shift;
	my $pairString = shift;
	return "" unless (defined $pairString);
	my $imsi = join "", map {scalar reverse($_)} split /\s+/, $pairString;
	$imsi =~ s/[^\d]//g; # strip padding 'F'
	return $imsi;
}

# the encoded representation below
#00 02 3B
# should read : 179
# assume 3 pairs in hex h, m, s
sub decodeDuration
{
	my $self = shift;
	my $pairString = shift;
	return 0 unless (defined $pairString);
	return 0 unless ($pairString =~ /[0-9A-F ]+/);
	my ($h, $m, $s) = split / /, $pairString;
	my $duration = (hex($s) + (60 * (hex($m))) + (60 * 60 * (hex($h))));
	return $duration;
}

# OLD decode revenue - not working!!
#24 2B 10 04
#sub decodeRevenue
#{
#       my $self = shift;
#       my $pairString = shift;
#       my @pairs = split /\s+/, $pairString;
#       shift @pairs;
#       shift @pairs;
#       my $revenue = join "", map {scalar reverse($_)} @pairs;
#       if ($revenue > 0)
#       {
#               $revenue = sprintf "%.2f", ($revenue / 100);
#       }
#       return $revenue;
#}


# NEW decode revenue
sub decodeRevenue
{
        my $self = shift;
        my $pairString = shift;
        my @pairs = split /\s+/, $pairString;
        my $pair1 = shift @pairs;
        my $pair2 = shift @pairs;

        my $revenue = join "", map {scalar reverse($_)} @pairs;
        if ($revenue > 0)
        {
                if ($pair1 eq "04") {
                        $revenue = sprintf "%.2f", ($revenue);
                }
                else {
                        $revenue = sprintf "%.2f", ($revenue / 10);
                }
        }
        return $revenue;
}


1;
