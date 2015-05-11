package Ascertain::UM::VFI::Aggregator::DS44;

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
	$self->D_USAGE_TYPE("CONTENT");        #AGGREGATOR KEY
	$self->D_SERVICE_TYPE(UNKNOWN);      #AGGREGATOR KEY
  #--- EVERYTHING ABOVE IS REQUIRED

	my $ST_ALL = FALSE;
	my $ST_CONTENT_POSTPAID = FALSE;
	my $ST_UNIDENT = TRUE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

	if ($d->{subscriberType} eq "POSTPAID")
	{
		$ST_CONTENT_POSTPAID = TRUE; push @serviceTypes, "ST_CONTENT_POSTPAID";
	}
	elsif ($d->{subscriberType} eq "PREPAID")
	{
		$ST_CONTENT_PREPAID = TRUE; push @serviceTypes, "ST_CONTENT_PREPAID";
	}
	else
	{
		push @serviceTypes, "ST_UNIDENT";
	}





	# ---- TIMESLOT
	# 05122009131220
	my $startDate = (defined $d->{startDateTime}) ? $d->{startDateTime} : "";
	$startDate =~ s/^(\d{2})(\d{2})(\d{4})(\d{2}).*/$3$2$1$4/;
	my $timeSlot = $startDate;
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT


	my $revenue = (defined $d->{revenue}) ? $d->{revenue} : 0;


	#--- EVERYTHING BELOW IS REQUIRED
	# ---- FILL AGGREGATION DATA STRUCTURE
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => 0,
			sum_bytes    => 0,
			sum_value    => $revenue
		}
	); # call the method in the parent class
	# ---- FILL AGGREGATION DATA STRUCTURE
}
#------------------------------------------------------------------------------



1;
