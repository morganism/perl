package Ascertain::UM::VFI::Aggregator::DS64;

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
	$self->D_USAGE_TYPE("MMS");        #AGGREGATOR KEY
	$self->D_SERVICE_TYPE(UNKNOWN);      #AGGREGATOR KEY
  #--- EVERYTHING ABOVE IS REQUIRED

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";
    $ST_UNIDENT = TRUE;

	#ServiceType = 10 
#and ServiceID in ("40","41","42","43","44","50","51")
	if 
	(
		defined $d->{Service_Type} and $d->{Service_Type} eq "10" and 
		defined $d->{Service_ID} and $d->{Service_ID} =~ /^4[0-5]|5[01]$/
	)
	{
		$ST_MMS = TRUE; push @serviceTypes, "ST_MMS";
		$ST_MMS_POSTPAID = TRUE; push @serviceTypes, "ST_MMS_POSTPAID";
		$ST_MMS_POSTPAID_HOME = TRUE; push @serviceTypes, "ST_MMS_POSTPAID_HOME";
		$ST_MMS_POSTPAID_HOME_MO = TRUE; push @serviceTypes, "ST_MMS_POSTPAID_HOME_MO";
		$ST_UNIDENT = FALSE;
	}

	


	# ---- TIMESLOT
#Call_Start_Date                                       101201
#Call_Start_Time                                       123734
	my $startDate = (defined $d->{Call_Start_Date}) ? "20" . $d->{Call_Start_Date} : "";
	my $startTime = (defined $d->{Call_Start_Time}) ? $d->{Call_Start_Time} : "";
	$startDate =~ s/^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/$1$2$3$4/g;
	my $timeSlot = $startDate . $startTime;
	$timeSlot =~ s/^(\d{10}).*/$1/;
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT

	my $volume = (defined $d->{Data_Volume}) ? $d->{Data_Volume} : 0;

	#--- EVERYTHING BELOW IS REQUIRED
	# ---- FILL AGGREGATION DATA STRUCTURE
	
	push @serviceTypes, "ST_UNIDENT" if ($ST_UNIDENT);
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
