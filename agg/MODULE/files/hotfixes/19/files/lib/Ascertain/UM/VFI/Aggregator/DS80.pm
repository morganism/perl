package Ascertain::UM::VFI::Aggregator::DS80;

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
	my $ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MO = FALSE;
	my $ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MT = FALSE;

	if (defined $d->{subscriberType} and defined $d->{TeleServiCode} and defined $d->{Application_Server} and $d->{Requested_Party_Adress} ne "tel:1741")
	{
		if ($d->{subscriberType} eq "0")
		{
			#subscriberType == '0' and TeleserviceCode == "65528" and Application_Server contains 'sip:ms.mo.roamcharg@eneas2.vodafone.es'
			if 
			(
				$d->{TeleServiCode} eq "65528" and
				$d->{Application_Server} eq 'sip:ms.mo.roamcharg@eneas2.vodafone.es'
			)
			{
				$ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MO = TRUE; push @serviceTypes, "ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MO";
				$ST_UNIDENT = FALSE;
			}
			#subscriberType == '0' and TeleserviceCode == "65530" and Application_Server contains 'sip:ms.mt.roamcharg@eneas2.vodafone.es;mode=rerouting'
			elsif 
			(
				$d->{TeleServiCode} eq "65530" and
				$d->{Application_Server} eq 'sip:ms.mt.roamcharg@eneas2.vodafone.es;mode=rerouting'
			)
			{
				$ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MT = TRUE; push @serviceTypes, "ST_VOICE_OUTBOUND_PREPAID_ROAMERS_MT";
				$ST_UNIDENT = FALSE;
			}
		}
		elsif ($d->{subscriberType} eq "1")
		{
			#subscriberType == '1' and TeleserviceCode == "65528" and Application_Server contains 'sip:ms.mo.roamcharg@eneas2.vodafone.es'
			if 
			(
				$d->{TeleServiCode} eq "65528" and
				$d->{Application_Server} eq 'sip:ms.mo.roamcharg@eneas2.vodafone.es'
			)
			{
				$ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MO = TRUE; push @serviceTypes, "ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MO";
				$ST_UNIDENT = FALSE;
			}
			#subscriberType == '1' and TeleserviceCode == "65530" and Application_Server contains 'sip:ms.mt.roamcharg@eneas2.vodafone.es;mode=rerouting'
			elsif 
			(
				$d->{TeleServiCode} eq "65530" and
				$d->{Application_Server} eq 'sip:ms.mt.roamcharg@eneas2.vodafone.es;mode=rerouting'
			)
			{
				$ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MT = TRUE; push @serviceTypes, "ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MT";
				$ST_UNIDENT = FALSE;
			}
		}
	}



	# ---- TIMESLOT
	# 20100426125511
	my $startDate = (defined $d->{StartRecordTimeChar}) ? $d->{StartRecordTimeChar} : "";
	$startDate =~ s/^(\d{10}).*/$1/;
	my $timeSlot = $startDate;
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT

	my $duration = (defined $d->{TotalUSU}) ? $d->{TotalUSU} : 0;

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
