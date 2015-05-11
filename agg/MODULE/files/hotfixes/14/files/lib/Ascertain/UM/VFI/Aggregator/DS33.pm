package Ascertain::UM::VFI::Aggregator::DS33;

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
use constant FALSE => undef;
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
	$self->D_TIMESLOT("1999011401");          #AGGREGATOR KEY
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
	my $ST_VOICE_INBOUND_ROAMERS_MO = FALSE;
	my $ST_VOICE_INBOUND_ROAMERS_MT = FALSE;
	my $ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MO = FALSE;
	my $ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MT = FALSE;
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

	if (defined $d->{RecordType} and $d->{RecordType} =~ /CAMEL_FORW|CAMEL_MOC|GSM2_FORW|GSM2_MOC|GSM_FORW|GSM_MOC|GSM_MTC|ICB2_MOC|ICBRR_MOC|ICBR_MOC|ICBV_MOC|ICB_MOC|ROAM_MTC|USSD_MOC/)
	{

		# ONXP 
		$self->IMSI($d->{CallingSubscriberIMSI}) if (defined $d->{CallingSubscriberIMSI});
		my $isOnxp = $self->isOnxpImsi();

		$ST_VOICE = TRUE; push @serviceTypes, "ST_VOICE";
		$self->D_USAGE_TYPE("VOICE");        #AGGREGATOR KEY
		$ST_UNIDENT = FALSE;

#Record_Type = GSM_MOC && 
#CalledPartyNumber doesn.t begin with 1741 starting from pos 6 (after NPI+TON+OICK)
#Record_Type = GSM_FORW 
#&& CalledPartyNumber doesn.t begin with 1741 starting from pos 6 (after NPI+TON+OICK)
#Record_Type in (ICB_MOC, ICBR_MOC, ICBV_MOC, GSM_MTC)
#Record_Type = GSM2_MOC  && INMarkingofMS is set and OICK field is equal to 177
#Record_Type = GSM2_FORW && INMarkingofMS is set and OICK field is equal to 177
		if 
		(
			(
				defined $d->{RecordType} and 
				$d->{RecordType} eq "GSM_MOC" and 
				defined $d->{CalledPartyNumber} and 
				substr($d->{CalledPartyNumber},5) !~ /^1741/
			) or
			(
				defined $d->{RecordType} and 
				$d->{RecordType} eq "GSM_FORW" and
				defined $d->{CalledPartyNumber} and 
				substr($d->{CalledPartyNumber},5) !~ /^1741/
			) or
			(
				defined $d->{RecordType} and 
				$d->{RecordType} =~ /ICB_MOC|ICBR_MOC|ICBV_MOC|GSM_MTC/
			) or
			(
				defined $d->{RecordType} and 
				$d->{RecordType} =~ /GSM2_MOC|GSM2_FORW/ and
				defined($d->{INMarkingOfMS}) and
				defined $d->{CalledPartyNumber} and 
				substr($d->{CalledPartyNumber},2,3) eq "177" # OICK
			) 
		)
		{
			$ST_VOICE_POSTPAID = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID";
			push @serviceTypes, "ST_ONXP_VOICE_POSTPAID" if ($isOnxp);
			$ST_VOICE_POSTPAID_HOME = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME";
			push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME" if ($isOnxp);
			if (defined $d->{RecordType} and $d->{RecordType} ne "GSM_MTC")
			{
				$ST_VOICE_POSTPAID_HOME_MO = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME_MO";
				push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME_MO" if ($isOnxp);
			}
		}
#Record_Type = GSM_FORW && CalledPartyNumber doesn.t begin with 1741 starting from pos 6 (after NPI+TON+OICK)
#Record_Type = GSM2_FORW && INMarkingofMS is set and OICK field is equal to 177
		# N.B. yes, this is a repeat of part of the above, but it follows the biz rules more easily
		if 
		(
			((defined $d->{RecordType} and $d->{RecordType} eq "GSM_FORW") and (substr($d->{CalledPartyNumber},5) !~ /^1741/)) or
			(
				(defined $d->{RecordType} and $d->{RecordType} eq "GSM2_FORW") and
				(defined($d->{INMarkingOfMS})) and
				(substr($d->{CalledPartyNumber},2,3) eq "177") # OICK
			) 
		)
		{
			$ST_VOICE_POSTPAID_HOME_CALL_FWD = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME_CALL_FWD";
			push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME_CALL_FWD" if ($isOnxp);
		}



# IMSI beings with 27201 but not an MVNO IMSI
# And (
# Record_Type in (ICBRR_MOC, ICB2_MOC )
# Record_Type = GSM_MOC && INMarkingOfMS is set && OICK field does contains a value and CalledPartyNumber starts with .1741.  starting from pos6 after NP1+TON +OICK
# Record_Type = GSM_FORW && INMarkingOfMS is set && OICK field does contains a value and CalledPartyNumber starts with .1741.  starting from pos6 after NP1+TON +OICK
# Record_Type = GSM2_MOC except if INMarkingofMS is set and OICK field is equal to 177 (i.e. all GSM2_MOCs are prepaid except where INMarkingofMS and OICK is 177)
# Record_Type = GSM2_FORW except if INMarkingofMS is set and OICK field is equal to 177 (i.e. all GSM2_FORW are prepaid except where INMarkingofMS and OICK is 177)
# )

# Change 8th June - all 3 PREPAID_VOICE rules now the same and with IMSI condition
		if (defined $d->{CallingSubscriberIMSI} and $d->{CallingSubscriberIMSI} =~ /^27201[^1]/)
		{
			if 
			(
				(
					defined $d->{RecordType} and 
					$d->{RecordType} =~ /ICBRR_MOC|ICB2_MOC/
				) or
				(
					defined $d->{RecordType} and 
					$d->{RecordType} =~ /GSM_MOC|GSM_FORW/ and
					defined($d->{INMarkingOfMS}) and
					defined $d->{CalledPartyNumber} and
					substr($d->{CalledPartyNumber},2,3) and # OICK
					substr($d->{CalledPartyNumber},5) =~ /^1741/
				) or
				(
					defined $d->{RecordType} and 
					$d->{RecordType} =~ /GSM2_MOC|GSM2_FORW/ and
					not 
					(
						defined $d->{INMarkingOfMS} and 
						defined $d->{CalledPartyNumber} and 
						substr($d->{CalledPartyNumber},2,3) eq "177"
					)
				)
			)
			{
				$ST_VOICE_PREPAID = TRUE; push @serviceTypes, "ST_VOICE_PREPAID";
				$ST_VOICE_PREPAID_HOME = TRUE; push @serviceTypes, "ST_VOICE_PREPAID_HOME";
				$ST_VOICE_PREPAID_HOME_MO = TRUE; push @serviceTypes, "ST_VOICE_PREPAID_HOME_MO";
			}
		}



#Record_Type = GSM_FORW && INMarkingOfMS is set && OICK field does contains a value and 
#CalledPartyNumber starts with .1741.  starting from pos6 after NP1+TON +OICK
#Record_Type = GSM2_FORW except if INMarkingofMS is set and OICK field is equal to 177 
	#(i.e. all GSM2_FORW are prepaid except where INMarkingofMS and OICK is 177)
		if 
		(
			(
				(defined $d->{RecordType} and $d->{RecordType} eq "GSM_FORW") and 
				(defined($d->{INMarkingOfMS})) and
				(defined substr($d->{CalledPartyNumber},2,3)) and # OICK
				(substr($d->{CalledPartyNumber},5) =~ /^1741/) 
			) or
			(
				(defined $d->{RecordType} and $d->{RecordType} eq "GSM2_FORW") and
				(not (defined($d->{INMarkingOfMS}) and substr($d->{CalledPartyNumber},2,3) eq "177"))
			) 
		)
		{
			$ST_VOICE_PREPAID_HOME_CALL_FWD = TRUE; push @serviceTypes, "ST_VOICE_PREPAID_HOME_CALL_FWD";
		}

		#Record_Type in (CAMEL_MOC, CAMEL_FORW,  USSD_MOC )
		if (defined $d->{RecordType} and $d->{RecordType} =~ /CAMEL_MOC|CAMEL_FORW|USSD_MOC/)
		{
			$ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MO = TRUE; push @serviceTypes, "ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MO";
		}
		elsif (defined $d->{RecordType} and $d->{RecordType} eq "ROAM_MTC")
		{
			$ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MT = TRUE; push @serviceTypes, "ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MT";
		}


	}
	elsif (defined $d->{RecordType} and $d->{RecordType} =~ /GSM_SMSMOC|GSM_SMSMTC|SMS2_MOC/)  # SMS2_MOC included even though not explicit with spec
	{
		$ST_SMS = TRUE; push @serviceTypes, "ST_SMS";
		$self->D_USAGE_TYPE("SMS");        #AGGREGATOR KEY
		$ST_SMS_HOME = TRUE; push @serviceTypes, "ST_SMS_HOME";
		$ST_UNIDENT = FALSE;

		if (defined $d->{RecordType} and $d->{RecordType} =~ /GSM_SMSMOC/)
		{
			$ST_SMS_HOME_MO = TRUE; push @serviceTypes, "ST_SMS_HOME_MO";
		}
		elsif (defined $d->{RecordType} and $d->{RecordType} =~ /GSM_SMSMTC/)
		{
			$ST_SMS_HOME_MT = TRUE; push @serviceTypes, "ST_SMS_HOME_MT";
		}
		elsif (defined $d->{RecordType} and $d->{RecordType} eq "SMS2_MOC")
		{
			$ST_SMS_PREPAID = TRUE; push @serviceTypes, "ST_SMS_PREPAID";
		}





#		# this is not in the spec next 36 lines   - SO REMOVED BY Steve Makinson 02-Jun-2011
#		if (defined $d->{CalledPartyNumber})
#		{
#			if ($d->{CalledPartyNumber} =~ /^VF/) # begins with VF
#			{
#				$ST_SMS_VODAFONE = TRUE; push @serviceTypes, "ST_SMS_VODAFONE"; # begins with VF
#			}
#			elsif ($d->{CalledPartyNumber} =~ /^BT/) # begins with BT
#			{
#				$ST_SMS_O2 = TRUE; push @serviceTypes, "ST_SMS_O2"; # begins with BT
#			}
#			elsif ($d->{CalledPartyNumber} =~ /^ME/)
#			{
#				$ST_SMS_METEOR = TRUE; push @serviceTypes, "ST_SMS_METEOR";
#			}
#			elsif ($d->{CalledPartyNumber} =~ /^HU/)
#			{
#				$ST_SMS_HUTCHINSON = TRUE; push @serviceTypes, "ST_SMS_HUTCHINSON";
#			}
#			elsif ($d->{CalledPartyNumber} =~ /^TE/)
#			{
#				$ST_SMS_TESCO = TRUE; push @serviceTypes, "ST_SMS_TESCO";
#			}
#			elsif ($d->{CalledPartyNumber} =~ /^AP/)
#			{
#				$ST_SMS_POSTFONE = TRUE; push @serviceTypes, "ST_SMS_POSTFONE";
#			}
#			elsif ($d->{CalledPartyNumber} =~ /^JM/)
#			{
#				$ST_SMS_JUSTMOBILE = TRUE; push @serviceTypes, "ST_SMS_JUSTMOBILE";
#			}
#			elsif ($d->{CalledPartyNumber} =~ /^0/)
#			{
#				$ST_SMS_OTHER_DEST = TRUE; push @serviceTypes, "ST_SMS_OTHER_DEST";
#			}
#			elsif ($d->{CalledPartyNumber} =~ /^5\d{4}/) # begins with 5 and has length of 5 digits
#			{
#				$ST_SMS_PREMIUM = TRUE; push @serviceTypes, "ST_SMS_PREMIUM"; # begins with 5 and has length of 5 digits
#			}
#		}
#		# this is not in the spec last 36 lines
	}




	# ---- TIMESLOT
	my $startDate = (defined $d->{DateForStartofCharge}) ? $d->{DateForStartofCharge} : "";
	my $startTime = (defined $d->{TimeForStartofCharge}) ? $d->{TimeForStartofCharge} : "";
	my $timeSlot = $startDate . $startTime;
	$timeSlot =~ s/^(\d{10}).*/$1/g;
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT

	my $duration = (defined $d->{ChargeableDuration}) ? $d->{ChargeableDuration} : 0;
	my $revenue = 0;
	if ($ST_SMS_PREPAID or $ST_VOICE_PREPAID)
	{
		$revenue = (defined $d->{INFinalChargeOfCall}) ? $d->{INFinalChargeOfCall} : 0;
	}


	#--- EVERYTHING BELOW IS REQUIRED
	# ---- FILL AGGREGATION DATA STRUCTURE
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



1;
