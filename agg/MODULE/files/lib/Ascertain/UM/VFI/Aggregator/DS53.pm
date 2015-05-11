package Ascertain::UM::VFI::Aggregator::DS53;

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


	my $ST_UNIDENT = TRUE;
	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

	my $PREPAID_FLAG = FALSE;
	my $POSTPAID_FLAG = FALSE;
	my $subsType = (defined $d->{SUBSCRIBER_TYPE}) ? $d->{SUBSCRIBER_TYPE} : UNKNOWN;
	if ($subsType eq "postpaid")
	{
		$POSTPAID_FLAG = TRUE;
	}
	elsif($subsType eq "prepaid")
	{
		$PREPAID_FLAG = TRUE;
	}

	my $WAP_FLAG = FALSE;
	my $GPRS_FLAG = FALSE;
	if 
	(
		(defined $d->{ACCESS_POINT_NAME} and $d->{ACCESS_POINT_NAME} ne "live.vodafone.com") and
		(defined $d->{ACCESS_POINT_NAME} and $d->{ACCESS_POINT_NAME} ne "wap.vodafone.ie")
	)
	{
		$GPRS_FLAG = TRUE;
	}
	elsif 
	(
		(defined $d->{ACCESS_POINT_NAME} and $d->{ACCESS_POINT_NAME} eq "live.vodafone.com") or
		(defined $d->{ACCESS_POINT_NAME} and $d->{ACCESS_POINT_NAME} eq "wap.vodafone.ie")
	)
	{
		$WAP_FLAG = TRUE;
	}


	my $ST_DATA_GPRS_PREPAID_STRIP = FALSE;
	my $ST_DATA_GPRS_POSTPAID_STRIP = FALSE;
	my $ST_DATA_WAP_PREPAID_STRIP = FALSE;
	my $ST_DATA_WAP_POSTPAID_STRIP = FALSE;
	if ($PREPAID_FLAG and $GPRS_FLAG)
	{
		$ST_DATA_GPRS_PREPAID_STRIP = TRUE; push @serviceTypes, "ST_DATA_GPRS_PREPAID_STRIP";
		$ST_UNIDENT = FALSE;
	}
	elsif ($POSTPAID_FLAG and $GPRS_FLAG)
	{
		$ST_DATA_GPRS_POSTPAID_STRIP = TRUE; push @serviceTypes, "ST_DATA_GPRS_POSTPAID_STRIP";
		$ST_UNIDENT = FALSE;
	}
	elsif ($PREPAID_FLAG and $WAP_FLAG)
	{
		$ST_DATA_WAP_PREPAID_STRIP = TRUE; push @serviceTypes, "ST_DATA_WAP_PREPAID_STRIP";
		$ST_UNIDENT = FALSE;
	}
	elsif ($POSTPAID_FLAG and $WAP_FLAG)
	{
		$ST_DATA_WAP_POSTPAID_STRIP = TRUE; push @serviceTypes, "ST_DATA_WAP_POSTPAID_STRIP";
		$ST_UNIDENT = FALSE;
	}
	
	# ---- TIMESLOT
	my $startDateTime = "";
	if (defined $d->{RECORD_START_TIME_FORMATTED}) 
	{
		$startDateTime = $d->{RECORD_START_TIME_FORMATTED};
	}
	elsif (defined $d->{SESSION_START_TIME_FORMATTED}) 
	{
		$startDateTime = $d->{SESSION_START_TIME_FORMATTED};
	}
	my $timeSlot = $startDateTime;
	$timeSlot =~ s/^(\d{10}).*/$1/g;
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT


	my $volume = (defined $d->{TOTAL_VOLUME}) ? $d->{TOTAL_VOLUME} : 0;

	push @serviceTypes, "ST_UNIDENT" if ($ST_UNIDENT);
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
