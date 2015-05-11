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

	$self->specifySourceInit();

	my $ST_ALL = FALSE;
	my $ST_DATA = FALSE;
	my $ST_DATA_GPRS = FALSE;
	my $ST_DATA_GPRS_POSTPAID = FALSE;
	my $ST_DATA_2G = FALSE;
	my $ST_DATA_3G = FALSE;
	my $ST_DATA_4G = FALSE;
	my $ST_DATA_2G_POSTPAID = FALSE;
	my $ST_DATA_3G_POSTPAID = FALSE;
	my $ST_DATA_4G_POSTPAID = FALSE;	
	my $ST_DATA_PARTNERS = FALSE;	
	my $ST_UNIDENT = FALSE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL                = TRUE; push @serviceTypes, "ST_ALL";
	$ST_DATA			  = TRUE; push @serviceTypes, "ST_DATA";
	$ST_DATA_GPRS          = TRUE; push @serviceTypes, "ST_DATA_GPRS";
	$ST_DATA_GPRS_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_GPRS_POSTPAID";

	
	if (defined $d->{CALL_SERVICE_CODE} && defined $d->{CALL_SERVICE_TYPE}) {
		if ( $d->{CALL_SERVICE_TYPE} eq '10' && $d->{CALL_SERVICE_CODE} eq '10' ) {
			$ST_DATA_2G = TRUE; push @serviceTypes, "ST_DATA_2G";	
			$ST_DATA_2G_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_2G_POSTPAID";			
		}
		elsif ( $d->{CALL_SERVICE_TYPE} eq '09' && $d->{CALL_SERVICE_CODE} eq '10' ) {
			$ST_DATA_3G = TRUE; push @serviceTypes, "ST_DATA_3G";	
			$ST_DATA_3G_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_3G_POSTPAID";			
		}
		elsif ( $d->{CALL_SERVICE_TYPE} eq '08' && $d->{CALL_SERVICE_CODE} eq '10' ) {
			$ST_DATA_4G = TRUE; push @serviceTypes, "ST_DATA_4G";	
			$ST_DATA_4G_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_4G_POSTPAID";			
		}	
	}

    if ($self->isPartner($d->{IMSI}) ne 0) {
        $ST_DATA_PARTNERS = TRUE; push @serviceTypes, "ST_DATA_PARTNERS";
		$self->specifySourceForAggRecords("ST_DATA_PARTNERS",$self->isPartner($d->{IMSI}));
    }


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
	my $duration = (defined $d->{CALL_DURATION}) ? $d->{CALL_DURATION} : 0;


	#--- EVERYTHING BELOW IS REQUIRED
	# ---- FILL AGGREGATION DATA STRUCTURE
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => $duration,
			sum_bytes    => $volume,
			sum_value    => 0
		}
	); # call the method in the parent class

}
#------------------------------------------------------------------------------



1;
