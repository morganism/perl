package Ascertain::UM::VFI::Aggregator::DS8;

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



	# reset vars
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
	my $ST_SMS_OUTBOUND_POSTPAID_ROAMERS_MO = FALSE;
	my $ST_SMS_OUTBOUND_POSTPAID_ROAMERS_MO_ARP = FALSE;
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

	my $ST_ITC_SMS_OUT_O2 = FALSE;
	my $ST_ITC_SMS_OUT_METEOR = FALSE;
	my $ST_ITC_SMS_OUT_HUTCHINSON = FALSE;
	my $ST_ITC_SMS_OUT_TESCO = FALSE;
	my $ST_ITC_SMS_OUT_POSTFONE = FALSE;
	my $ST_ITC_SMS_OUT_JUSTMOBILE = FALSE;
	my $ST_ITC_SMS_OUT_LYCA = FALSE;
	my $ST_ITC_SMS_OUT_OTHER_DEST = FALSE;
	my $ST_ITC_SMS_OUT = FALSE;
	
    my $ST_ARP_FLAG = FALSE;

	my $ST_UNIDENT = TRUE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

	# common var
	$ST_SMS = TRUE if (defined $d->{TrafficEventType} and $d->{TrafficEventType} eq "5"); # one of: 21,22,81,82,83,84,86,88,89

    if (defined $d->{PrepaidServerIdentity} and $d->{PrepaidServerIdentity} eq "1") {
       $ST_ARP_FLAG = TRUE;
    }

	if ($ST_SMS)
	{
	
		# dimensions
        # UsageType,SubsType,ServiceType(Destination),CallDirection,Roaming,TimeSlot
		my $usageType = "SMS";
		$self->D_USAGE_TYPE($usageType); #AGGREGATOR KEY

		# DestinationAddress and OriginatingAddress look like " 91   3576536563565"
        # trim it
        my $destinationAddress = (defined $d->{DestinationAddress}) ? $d->{DestinationAddress} : "";
        my $originatingAddress = (defined $d->{OriginatingAddress}) ? $d->{OriginatingAddress} : "";
        $destinationAddress =~ s/^\d+\s+//;
        $originatingAddress =~ s/^\d+\s+//;

		if (not $ST_ARP_FLAG) {
			$ST_UNIDENT = FALSE;
			$ST_SMS = TRUE; push @serviceTypes, "ST_SMS";
			$ST_SMS_HOME = TRUE; push @serviceTypes, "ST_SMS_HOME";

			if 
			(
				($destinationAddress =~ /^5\d{4}/) or ($originatingAddress =~ /^5\d{4}/)#
			) # begins with 5 and has length of 5 digits
			{
				$ST_SMS_PREMIUM = TRUE; push @serviceTypes, "ST_SMS_PREMIUM";
			}


			if ((defined $d->{MessageSource} and $d->{MessageSource} eq "0") and ($d->{OriginatingIMSI} =~ /^27201/))
			{
				$ST_SMS_HOME_MO = TRUE; push @serviceTypes, "ST_SMS_HOME_MO";
			}
			elsif (defined $d->{OriginatingIMSI} and $d->{OriginatingIMSI} eq "0000000000000000")
			{
				$ST_SMS_HOME_MT = TRUE; push @serviceTypes, "ST_SMS_HOME_MT";
			}
		}

		if ($d->{SourceNode} !~ /^1208001204538367/ and $d->{SourceNode} ne "0000000000000000")
		{
			if ($ST_ARP_FLAG) {
				$ST_SMS_OUTBOUND_POSTPAID_ROAMERS_MO_ARP = TRUE; push @serviceTypes, "ST_SMS_OUTBOUND_POSTPAID_ROAMERS_MO_ARP";
			}
			else {
				$ST_SMS_OUTBOUND_POSTPAID_ROAMERS_MO = TRUE; push @serviceTypes, "ST_SMS_OUTBOUND_POSTPAID_ROAMERS_MO";
			}
		}


		# Interconnect Service Types

		my $destinationIMSI = (defined $d->{DestinationIMSI}) ? $d->{DestinationIMSI} : "";
		$destinationIMSI =~ s/\s+//;

		# These are not strictly required but will leave them here for now
		if ($destinationIMSI  =~ /^27202/) {
			$ST_ITC_SMS_OUT_O2 = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_O2";
		}
		elsif ($destinationIMSI  =~ /^27203/) {
			$ST_ITC_SMS_OUT_METEOR = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_METEOR";
		}
		elsif ($destinationIMSI  =~ /^27205/) {
			$ST_ITC_SMS_OUT_HUTCHINSON = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_HUTCHINSON";
		}
		elsif ($destinationIMSI  =~ /^27211/) {
			$ST_ITC_SMS_OUT_TESCO = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_TESCO";
		}
		elsif ($destinationIMSI  =~ /^27201110/) {
			$ST_ITC_SMS_OUT_POSTFONE = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_POSTFONE";
		}
		elsif ($destinationIMSI  =~ /^27201111/) {
			$ST_ITC_SMS_OUT_JUSTMOBILE = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_JUSTMOBILE";
		}
		elsif ($destinationIMSI  =~ /^27213/) {
			$ST_ITC_SMS_OUT_LYCA = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_LYCA";
		}
		elsif ($destinationIMSI  !~ /^27201/ and $destinationAddress  !~ /^00000/) {
			$ST_ITC_SMS_OUT_OTHER_DEST = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_OTHER_DEST";
		}

		if (    (   $destinationIMSI  !~ /^27201/ 
                         or $destinationIMSI  =~ /^27201111/ # Postfone
			 or $destinationIMSI  =~ /^27201110/ # Just Mobile
			)
		    and $destinationIMSI  !~ /^00000/
		   )
                {
			$ST_ITC_SMS_OUT = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT";
		}


		my $startDateTime = (defined $d->{AcceptTime}) ? $d->{AcceptTime} : "";
		$startDateTime =~ s:^(\d{2})(\d{2})(\d{2})(\d{2})(\d*)$:20$1$2$3$4:;
		my $timeSlot = $startDateTime;
		unless ($timeSlot =~ m/\d{10}/)
		{
			die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
		}
		$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY

	}
	else
	{
		$ST_UNIDENT = TRUE; push @serviceTypes, "ST_UNIDENT";
	}



	#--- EVERYTHING BELOW IS REQUIRED
	# ---- FILL AGGREGATION DATA STRUCTURE
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => 0,
			sum_bytes    => 0,
			sum_value    => 0
		}
	); # call the method in the parent class
}
#------------------------------------------------------------------------------



1;
