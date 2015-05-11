package Ascertain::UM::VFI::Aggregator::DS55;

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
	$self->D_SERVICE_TYPE(UNKNOWN);      #AGGREGATOR KEY
  $self->D_USAGE_TYPE("DATA");        #AGGREGATOR KEY
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
	my $ST_SMS_PREPAID                   = FALSE;
	my $ST_SMS_OTHER_INBOUND_ROAMERS_MO  = FALSE;
	my $ST_SMS_OTHER_INBOUND_ROAMERS_MT  = FALSE;
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
	my $ST_UNIDENT = FALSE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL                = TRUE; push @serviceTypes, "ST_ALL";
	$ST_DATA_GPRS          = TRUE; push @serviceTypes, "ST_DATA_GPRS";
	$ST_DATA_GPRS_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_GPRS_POSTPAID";


	#-- TIMESLOT ----------------------------------------------------------------
	my $startDate = "20";
	if (defined $d->{CALL_START_DATETIME})
	{
		$startDate .= $d->{CALL_START_DATETIME};
	}
	$startDate =~ s/^(\d{10}).*/$1/;
	my $timeSlot = $startDate;
  unless ($timeSlot =~ m/\d{10}/)
  {
    die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
  }
	$self->D_TIMESLOT($timeSlot);#AGGREGATOR KEY
	#-- TIMESLOT ----------------------------------------------------------------


	my $volume = (defined $d->{DATA_VOLUME}) ? $d->{DATA_VOLUME} : 0;


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

}
#------------------------------------------------------------------------------



1;
