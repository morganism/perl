package Ascertain::UM::VFI::Aggregator::DS81;

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
  $self->D_USAGE_TYPE("VOICE");        #AGGREGATOR KEY
  #--- EVERYTHING ABOVE IS REQUIRED

	my $ST_ALL = FALSE;
	my $ST_CONTENT_POSTPAID = FALSE;
	my $ST_UNIDENT = TRUE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

	my $ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MO = FALSE;
	my $ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MT = FALSE;

	if 
	(
		defined $d->{Call_Direction}   and 
		defined $d->{Call_Type}        and $d->{Call_Type}        eq "V"     and
		defined $d->{Call_Service}     and $d->{Call_Service}     eq "VOICE" and
		defined $d->{Network_Location} and $d->{Network_Location} eq "VPLMN"
	)
	{
		#Call_Direction == 'O' and Call_Type == 'V' and Call_Service == 'VOICE' and Network_Location == 'VPLMN'
		if ($d->{Call_Direction} eq "O")
		{
			$ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MO = TRUE; push @serviceTypes, "ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MO";
			$ST_UNIDENT = FALSE;
		}
		#Call_Direction == 'T' and Call_Type == 'V' and Call_Service == 'VOICE' and Network_Location == 'VPLMN'
		elsif ($d->{Call_Direction} eq "T")
		{
			$ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MT = TRUE; push @serviceTypes, "ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MT";
			$ST_UNIDENT = FALSE;
		}
	}




	# ---- TIMESLOT
	# 20100426125511
	my $startDate = (defined $d->{StartRecordTimeChar}) ? $d->{StartRecordTimeChar} : "";
	$startDate =~ s/[\s:-]//g; # 2010-04-15 11:43:26 ---> 20100415114326
	$startDate =~ s/^(\d{10}).*/$1/;
	my $timeSlot = $startDate;
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT

	my $duration = (defined $d->{TotalUSU}) ? $d->{TotalUSU} : 0;
	my $revenue = 0;
	#X sum(CCN balance before - CCN balance after)
	if (defined $d->{CCN_balance_before} and defined $d->{CCN_balance_after})
	{
		$revenue = $d->{CCN_balance_before} - $d->{CCN_balance_after};
	}

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
			sum_value    => $revenue
		}
	); # call the method in the parent class
	# ---- FILL AGGREGATION DATA STRUCTURE
}
#------------------------------------------------------------------------------



1;
