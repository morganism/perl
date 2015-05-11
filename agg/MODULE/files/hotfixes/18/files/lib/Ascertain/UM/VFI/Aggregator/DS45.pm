package Ascertain::UM::VFI::Aggregator::DS45;

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
	$self->D_USAGE_TYPE("DATA");        #AGGREGATOR KEY
	$self->D_SERVICE_TYPE(UNKNOWN);      #AGGREGATOR KEY
  #--- EVERYTHING ABOVE IS REQUIRED

	my $ST_DATA_GPRS_PREPAID = FALSE;
	my $ST_DATA_WAP_PREPAID = FALSE;

	my @serviceTypes; # each time a service type tests TRUE push it
	my $ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

	if (defined $d->{CCN_ExtInt1} and $d->{CCN_ExtInt1} !~ /^[4-8]$/)
	{
		$ST_DATA_GPRS_PREPAID = TRUE; push @serviceTypes, "ST_DATA_GPRS_PREPAID";
	}
	else
	{
		$ST_DATA_WAP_PREPAID = TRUE; push @serviceTypes, "ST_DATA_WAP_PREPAID";
	}

  $self->D_USAGE_TYPE("DATA");        #AGGREGATOR KEY


	# ---- TIMESLOT
	#2010-12-17 11:53:46
	my $startDate = (defined $d->{CCN_TriggerTime}) ? $d->{CCN_TriggerTime} : "";
	$startDate =~ s/^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/$1$2$3$4/g;
	my $timeSlot = $startDate;
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT

	my $volume = (defined $d->{CCN_DataVolume}) ? $d->{CCN_DataVolume} : 0;
	my $revenue = 0;
	if (defined $d->{CCN_AccountValueBefore} and defined $d->{CCN_AccountValueAfter})
	{
		$revenue = $d->{CCN_AccountValueBefore} - $d->{CCN_AccountValueAfter};
	}


	#--- EVERYTHING BELOW IS REQUIRED
	# ---- FILL AGGREGATION DATA STRUCTURE
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => 0,
			sum_bytes    => $volume,
			sum_value    => $revenue
		}
	); # call the method in the parent class
	# ---- FILL AGGREGATION DATA STRUCTURE
}
#------------------------------------------------------------------------------



1;
