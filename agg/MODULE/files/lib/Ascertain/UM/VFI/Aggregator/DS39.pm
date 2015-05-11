package Ascertain::UM::VFI::Aggregator::DS39;

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
	my $ST_DATA = FALSE;
	my $ST_DATA_WAP = FALSE;
	my $ST_DATA_WAP_POSTPAID = FALSE;
	my $ST_DATA_PARTNERS = FALSE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

	$self->specifySourceInit();

	$ST_DATA = TRUE; push @serviceTypes, "ST_DATA";
	$ST_DATA_WAP = TRUE; push @serviceTypes, "ST_DATA_WAP";	
	$ST_DATA_WAP_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_WAP_POSTPAID";
	
	if ($self->isPartner($d->{Served_IMSI}) ne 0) {
		$ST_DATA_PARTNERS = TRUE; push @serviceTypes, "ST_DATA_PARTNERS";
		$self->specifySourceForAggRecords("ST_DATA_PARTNERS",$self->isPartner($d->{Served_IMSI}));
	}



  	$self->D_USAGE_TYPE("DATA");        #AGGREGATOR KEY



	# ---- TIMESLOT
	# StartTime 101216221124
	my $startDateTime = (defined $d->{StartTime}) ? "20" . $d->{StartTime} : "";
	my $timeSlot = $startDateTime;
	$timeSlot =~ s/^(\d{10}).*/$1/g;
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT


	my $volume = (defined $d->{TAP1_DataVolume}) ? $d->{TAP1_DataVolume} : 0;
	my $duration = (defined $d->{TAP1_Call_Duration}) ? $d->{TAP1_Call_Duration} : 0;
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
	# ---- FILL AGGREGATION DATA STRUCTURE
}
#------------------------------------------------------------------------------



1;
