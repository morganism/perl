package Ascertain::UM::VFI::Aggregator::DS4;

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
	my $ST_VOICE = FALSE;
	my $ST_VOICE_POSTPAID = FALSE;
	my $ST_VOICE_POSTPAID_HOME = FALSE;
	my $ST_VOICE_POSTPAID_HOME_MO = FALSE;
	my $ST_VOICE_POSTPAID_HOME_CALL_FWD = FALSE;
	my $ST_UNIDENT = TRUE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

	# ONXP 
	$self->IMSI($d->{IMSI}) if (defined $d->{IMSI});

	if ($d->{Record_Type} eq "20" or $d->{Record_Type} eq "21" or $d->{Record_Type} eq "30")
	{
		my $isOnxp = $self->isOnxpImsi();

		$ST_UNIDENT = FALSE;
		$ST_VOICE = TRUE; push @serviceTypes, "ST_VOICE";
		$ST_VOICE_POSTPAID = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID";
		push @serviceTypes, "ST_ONXP_VOICE_POSTPAID" if ($isOnxp);
		$self->D_USAGE_TYPE("VOICE");        #AGGREGATOR KEY

		if (defined $d->{IMSI} and $d->{IMSI} =~ /^27201[^1]/) # but not MVNO
		{
			$ST_VOICE_POSTPAID_HOME = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME";
			push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME" if ($isOnxp);

			if (defined $d->{Record_Type} and $d->{Record_Type} eq "20")
			{
				$ST_VOICE_POSTPAID_HOME_MO = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME_MO";
				push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME_MO" if ($isOnxp);
			}
			elsif (defined $d->{Record_Type} and $d->{Record_Type} eq "21")
			{
				$ST_VOICE_POSTPAID_HOME_CALL_FWD = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME_CALL_FWD";
				push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME_CALL_FWD" if ($isOnxp);
			}
		}
	}


	# ---- TIMESLOT
	#2010-12-17 11:53:46
	my $startDate = (defined $d->{Call_End_Date}) ? $d->{Call_End_Date} : "";
	my $startTime = (defined $d->{Call_End_Time}) ? $d->{Call_End_Time} : "";
	my $timeSlot = "20" . $startDate . $startTime;
	$timeSlot =~ s/^(\d{10}).*/$1/;
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT

	my $duration = (defined $d->{Call_Duration}) ? $d->{Call_Duration} : 0;

	#--- EVERYTHING BELOW IS REQUIRED
	# ---- FILL AGGREGATION DATA STRUCTURE
	push @serviceTypes, "ST_UNIDENT" if ($ST_UNIDENT);
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => $duration,
			sum_bytes    => 0,
			sum_value    => 0
		}
	); # call the method in the parent class
	# ---- FILL AGGREGATION DATA STRUCTURE
}
#------------------------------------------------------------------------------



1;
