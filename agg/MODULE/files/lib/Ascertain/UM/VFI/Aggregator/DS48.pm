package Ascertain::UM::VFI::Aggregator::DS48;

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

	my $ST_ICT_MMS = FALSE;
	my $ST_ICT_MMS_OUT = FALSE;
	my $ST_ICT_MMS_IN = FALSE;
	
	my $ST_UNIDENT = TRUE;


	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";
	$ST_MMS = TRUE; push @serviceTypes, "ST_MMS";
	$self->D_USAGE_TYPE("MMS");        #AGGREGATOR KEY



	# these are used below in both POST and PRE
	my $HOME_FLAG = FALSE;
	my $HOME_MO_FLAG = FALSE;
	if (defined $d->{ORIG_MMSC} and $d->{ORIG_MMSC} eq "mms.vodafone.ie")
	{
		$HOME_FLAG = TRUE;
	}
	if 
	(
		$HOME_FLAG and 
		defined $d->{SUCCESS_INDICATOR} and $d->{SUCCESS_INDICATOR} eq "128" and 
		defined $d->{OIWTYPE} and $d->{OIWTYPE} eq "0"
	)
	{
		$HOME_MO_FLAG = TRUE;
	}

	if (defined $d->{SENDER_CHARGING_TYPE} and $d->{SENDER_CHARGING_TYPE} ne "1")
	{
		$ST_MMS_POSTPAID = TRUE; push @serviceTypes, "ST_MMS_POSTPAID";

		if ($HOME_FLAG)
		{
			$ST_MMS_POSTPAID_HOME = TRUE; push @serviceTypes, "ST_MMS_POSTPAID_HOME";

	#ST_MMS_POSTPAID_HOME 
	#and SuccessIndicator = 128 
	#and OIWType = 0
			if ($HOME_MO_FLAG)
			{
				$ST_MMS_POSTPAID_HOME_MO = TRUE; push @serviceTypes, "ST_MMS_POSTPAID_HOME_MO";
			}
		}
	}
	elsif (defined $d->{SENDER_CHARGING_TYPE} and $d->{SENDER_CHARGING_TYPE} eq "1")
	{
		$ST_MMS_PREPAID = TRUE; push @serviceTypes, "ST_MMS_PREPAID";

		if ($HOME_FLAG)
		{
			$ST_MMS_PREPAID_HOME = TRUE; push @serviceTypes, "ST_MMS_PREPAID_HOME";

	#ST_MMS_PREPAID_HOME 
	#and SuccessIndicator = 128 
	#and OIWType = 0
			if ($HOME_MO_FLAG)
			{
				$ST_MMS_PREPAID_HOME_MO = TRUE; push @serviceTypes, "ST_MMS_PREPAID_HOME_MO";
			}
		}
	}
	else
	{
		# should not be hit
		push @serviceTypes, "ST_UNIDENT";
	}



	# INTERCONNECT Service Types

	if (     ( defined $d->{MSG_LEN} and $d->{MSG_LEN} > 0)
	     and ( defined $d->{OADDR} and defined $d->{DADDR} )
	     and ( defined $d->{SUCCESS_INDICATOR} and $d->{SUCCESS_INDICATOR} eq "128" ) # TODO: are further values required?
	     and ( (   defined $d->{DEST_MMSC} and $d->{DEST_MMSC} ne "mms.vodafone.ie" )
		    or 
		   (   defined $d->{ORIG_MMSC} and $d->{ORIG_MMSC} ne "mms.vodafone.ie" )
		 ) 
	   )
	{
		$ST_ITC_MMS = TRUE; push @serviceTypes, "ST_ITC_MMS";

		if ( defined $d->{DIWTYPE} and $d->{DIWTYPE} eq "450" ) # these values need to be confirmed
		{
			$ST_ITC_MMS_OUT = TRUE; push @serviceTypes, "ST_ITC_MMS_OUT";
		}
		elsif ( defined $d->{OIWTYPE} and $d->{OIWTYPE} eq "451") # these values need to be confirmed
		{
			$ST_ITC_MMS_IN = TRUE; push @serviceTypes, "ST_ITC_MMS_IN";
		}
	}

	# ---- TIMESLOT
	# 2011-01-20 14:50:05
	my $startDate = (defined $d->{INCOMING_TIME_DATE}) ? $d->{INCOMING_TIME_DATE} : "";
	$startDate =~ s/^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/$1$2$3$4/g;
	my $timeSlot = $startDate;
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT

	my $volume = (defined $d->{MSG_LEN}) ? $d->{MSG_LEN} : 0;


	#--- EVERYTHING BELOW IS REQUIRED
	# ---- FILL AGGREGATION DATA STRUCTURE
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => 0,
			sum_bytes    => $volume,
			sum_value    => 0
		}
	); # call the method in the parent class
	# ---- FILL AGGREGATION DATA STRUCTURE
}
#------------------------------------------------------------------------------



1;
