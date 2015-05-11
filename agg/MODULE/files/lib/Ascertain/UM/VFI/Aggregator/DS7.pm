pckage Ascertain::UM::VFI::Aggregator::DS6;

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
	#$self->D_TIMESLOT("1999011401");          #AGGREGATOR KEY
	#$self->D_USAGE_TYPE(UNKNOWN);        #AGGREGATOR KEY
	#$self->D_SERVICE_TYPE(UNKNOWN);      #AGGREGATOR KEY
	#--- EVERYTHING ABOVE IS REQUIRED


	# reset vars
	my $ST_ALL = FALSE;
	my $ST_DATA = FALSE;
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
	my $ST_DATA_2G = FALSE;
	my $ST_DATA_3G = FALSE;
	my $ST_DATA_4G = FALSE;
	my $ST_DATA_2G_POSTPAID = FALSE;
	my $ST_DATA_3G_POSTPAID = FALSE;
	my $ST_DATA_4G_POSTPAID = FALSE;
	my $ST_UNIDENT = TRUE;
	my $ST_VOICE_POSTPAID_HOME_MO_FREE = FALSE;

	my $ST_DATA_PARTNERS = FALSE;

	my $ST_DATA_IN_BUNDLE = FALSE;
	my $ST_DATA_OUT_BUNDLE = FALSE;


	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

	$self->specifySourceInit();

	# ----- PREDEFINE variables used in data structure
	my $usageType     = UNKNOWN;
	my $serviceType   = UNKNOWN;
	my $subsType      = "POST"; # always POST as we are processing ICCS data, which is postpaid by definition
	my $callDirection = UNKNOWN;
	my $roaming       = UNKNOWN;
	# ----- PREDEFINE variables used in data structure


	if (defined $d->{call_class} and $d->{call_class} =~ /^GPRS/)
	{
		$ST_DATA = TRUE; push @serviceTypes, "ST_DATA";
                $ST_UNIDENT = FALSE;
		$usageType = "DATA";

		if ($d->{call_class} eq "GPRS5" or $d->{call_class} eq "GPRS6") 
		{
			$ST_DATA_WAP = TRUE; push @serviceTypes, "ST_DATA_WAP";
			if (defined $d->{call_plmn_code} and $d->{call_plmn_code} ne "IRLVF")
			{
				$ST_DATA_WAP_OUTBOUND_ROAMERS = TRUE; push @serviceTypes, "ST_DATA_WAP_OUTBOUND_ROAMERS";
			}
		}
		else {
			$ST_DATA_GPRS = TRUE; push @serviceTypes, "ST_DATA_GPRS";
			if (defined $d->{call_plmn_code} and $d->{call_plmn_code} ne "IRLVF")
                        {
                                $ST_DATA_GPRS_OUTBOUND_ROAMERS = TRUE; push @serviceTypes, "ST_DATA_GPRS_OUTBOUND_ROAMERS";
                        }
		}

	        if (defined $d->{call_service_code} && defined $d->{call_service_type})
        	{
               		if ($d->{call_service_code} eq '10' && $d->{call_service_type} eq '10')
                	{
                 	        $ST_DATA_2G = TRUE; push @serviceTypes, "ST_DATA_2G";
                	}
                	elsif ($d->{call_service_code} eq '10' && $d->{call_service_type} eq '09')
                	{
                        	$ST_DATA_3G = TRUE; push @serviceTypes, "ST_DATA_3G";
                	}
                	elsif ($d->{call_service_code} eq '10' && $d->{call_service_type} eq '08')
                	{
                        	$ST_DATA_4G = TRUE; push @serviceTypes, "ST_DATA_4G";
                	}
        	}
	}

	if ($ST_DATA) {

		if ($d->{call_discount_price} > 0.00) {
           		 $ST_DATA_IN_BUNDLE = TRUE; push @serviceTypes, "ST_DATA_IN_BUNDLE";
        	}
        	else {
            		$ST_DATA_OUT_BUNDLE = TRUE; push @serviceTypes, "ST_DATA_OUT_BUNDLE";
        	}
	}

		
	# ---- USAGE


	# ---- TIMESLOT
	# Constants
	my %MONTH_NUMBER = (
	    'JAN' => 1,
  	    'FEB' => 2,
	    'MAR' => 3,
	    'APR' => 4,
	    'MAY' => 5,
	    'JUN' => 6,
	    'JUL' => 7,
	    'AUG' => 8,
	    'SEP' => 9,
	    'OCT' => 10,
	    'NOV' => 11,
	    'DEC' => 12,    
	);

	my $startDate = (defined $d->{CALL_START_DATE}) ? $d->{CALL_START_DATE} : "";
	my $startTime = "";
	my $timeSlot = "";
	$startDate =~ s/\s//g;
	if ($startDate =~ m:^(\d+)-([A-Z]{3})-(\d+)$:)
	{
		my $month = $MONTH_NUMBER{ $2 };
		$startDate = sprintf "%4d%02d%02d", "$3",$month,$1;
		$startTime = (defined $d->{DAILY_START_TIME}) ? $d->{DAILY_START_TIME} : "";
		$startTime =~ s/^(\d{2}):(\d{2}):(\d{2})/$1/;
		$timeSlot = $startDate . $startTime;
	}
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT


	if ($ST_UNIDENT) {
		$ST_UNIDENT = TRUE; push @serviceTypes, "ST_UNIDENT";
	}

	# ---- RULES
	$self->D_USAGE_TYPE($usageType);        #AGGREGATOR KEY

	my $duration = (defined $d->{call_duration}) ? $d->{call_duration} : 0;
	my $volume   = (defined $d->{call_data_vol}) ? $d->{call_data_vol} : 0;
	my $revenue  = (defined $d->{call_net_price}) ? $d->{call_net_price} : 0;

	#--- EVERYTHING BELOW IS REQUIRED
	# ---- FILL AGGREGATION DATA STRUCTURE
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => $duration,
			sum_bytes    => $volume,
			sum_value    => $revenue
		}
	); # call the method in the parent class
	# ---- FILL AGGREGATION DATA STRUCTURE
}
#------------------------------------------------------------------------------



