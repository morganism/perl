package Ascertain::UM::VFI::Aggregator::DS40;

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
  $self->D_USAGE_TYPE("CONTENT");        #AGGREGATOR KEY
  #--- EVERYTHING ABOVE IS REQUIRED

	my $ST_ALL = FALSE;
	my $ST_CONTENT_POSTPAID = FALSE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";
	$ST_CONTENT_POSTPAID = TRUE; push @serviceTypes, "ST_CONTENT_POSTPAID";


	# ---- TIMESLOT
	my $startDate = (defined $d->{startDateTime}) ? "20" . $d->{startDateTime} : "";
	$startDate =~ s/^(\d{10}).*/$1/;
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
