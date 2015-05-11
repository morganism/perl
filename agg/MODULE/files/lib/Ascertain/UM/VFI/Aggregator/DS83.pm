package Ascertain::UM::VFI::Aggregator::DS83;

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
	$self->D_SERVICE_TYPE("DATA");      #AGGREGATOR KEY
  #--- EVERYTHING ABOVE IS REQUIRED

	my $ST_ALL = FALSE;
	my $ST_DATA = FALSE;
	my $ST_DATA_GPRS = FALSE;
	my $ST_DATA_WAP = FALSE;
	my $ST_DATA_GPRS_POSTPAID = FALSE;
	my $ST_DATA_WAP_POSTPAID = FALSE;
	my $ST_DATA_GPRS_OUTBOUND_ROAMERS = FALSE;
	my $ST_DATA_WAP_OUTBOUND_ROAMERS = FALSE;
	my $ST_DATA_2G = FALSE;
	my $ST_DATA_3G = FALSE;
	my $ST_DATA_4G = FALSE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";
	$self->D_USAGE_TYPE("DATA");        #AGGREGATOR KEY

	# ---- TIMESLOT
	#2010-12-17 11:53:46
	my $startDateTime = (defined $d->{CALL_START_TIME}) ? $d->{CALL_START_TIME} : "";
	my $timeSlot = $startDateTime;
	$timeSlot =~ s/^(\d{10}).*/$1/;
	unless ($timeSlot =~ m/\d{10}/)
	{
                # Use generation_timestamp field if call_start_time not available (this is for no 46 event types)
                my $genTimestamp = (defined $d->{GENERATION_TIMESTAMP}) ? $d->{GENERATION_TIMESTAMP} : "";
                $timeSlot = $genTimestamp;
                $timeSlot =~ s/^(\d{10}).*/$1/;
                unless ($timeSlot =~ m/\d{10}/)
                {
                        die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
                }
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT

	# --- start the business rules here
	if 
	(
		(defined $d->{EVENT_LABEL} and $d->{EVENT_LABEL} eq "46") and
		(
			defined $d->{EVENT_RESULT} and 
				(
					$d->{EVENT_RESULT} eq "1" or
					$d->{EVENT_RESULT} eq "19"
				)
		) and
		(defined $d->{ACCESS_POINT} and $d->{ACCESS_POINT} ne "mms.vodafone.net")
	)
	{
		$ST_DATA = TRUE; push @serviceTypes, "ST_DATA";
	}
	else {
		$ST_UNIDENT = TRUE; push @serviceTypes, "ST_UNIDENT";
	}

	if ($ST_DATA)
	{ 
		if (defined $d->{ACCESS_POINT})
		{
			if ($d->{ACCESS_POINT} ne "live.vodafone.ie")
			{
				$ST_DATA_GPRS = TRUE; push @serviceTypes, "ST_DATA_GPRS";
			}
			else
			{
				$ST_DATA_WAP = TRUE; push @serviceTypes, "ST_DATA_WAP";
			}

			if (defined $d->{PRE_POST_PAID_CALL} and $d->{PRE_POST_PAID_CALL} eq "2")
			{
				if ($ST_DATA_GPRS)
				{
					$ST_DATA_GPRS_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_GPRS_POSTPAID";
				}
				else
				{
					$ST_DATA_WAP_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_WAP_POSTPAID";
				}
			}

			if (defined $d->{ROAMING_INDICATOR} and $d->{ROAMING_INDICATOR} eq "2")
			{
				if ($ST_DATA_GPRS)
				{
					$ST_DATA_GPRS_OUTBOUND_ROAMERS = TRUE; push @serviceTypes, "ST_DATA_GPRS_OUTBOUND_ROAMERS";
				}
				else
				{
					$ST_DATA_WAP_OUTBOUND_ROAMERS = TRUE; push @serviceTypes, "ST_DATA_WAP_OUTBOUND_ROAMERS";
				}
			}
		}

		if (defined $d->{ENHANCED_ACCESS_TECHNOLOGY_TYPE})
		{
			if ($d->{ENHANCED_ACCESS_TECHNOLOGY_TYPE} eq "2")
			{
				$ST_DATA_2G = TRUE; push @serviceTypes, "ST_DATA_2G";
			}
			elsif ($d->{ENHANCED_ACCESS_TECHNOLOGY_TYPE} eq "1")
			{
				$ST_DATA_3G = TRUE; push @serviceTypes, "ST_DATA_3G";
			}
			elsif ($d->{ENHANCED_ACCESS_TECHNOLOGY_TYPE} eq "6")
			{
				$ST_DATA_4G = TRUE; push @serviceTypes, "ST_DATA_4G";
			}
		}
	}

	my $sum_bytes = (defined $d->{ROUNDED_CALL_VOLUME}) ? $d->{ROUNDED_CALL_VOLUME} : "0";
	my $sum_value = (defined $d->{CALL_COST}) ? $d->{CALL_COST} : "0";
	my $sum_duration = (defined $d->{PDP_DURATION}) ? $d->{PDP_DURATION} : "0";

	#--- EVERYTHING BELOW IS REQUIRED
	# ---- FILL AGGREGATION DATA STRUCTURE
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => $sum_duration,
			sum_bytes    => $sum_bytes,
			sum_value    => $sum_value
		}
	); # call the method in the parent class
	# ---- FILL AGGREGATION DATA STRUCTURE
}
#------------------------------------------------------------------------------



1;
