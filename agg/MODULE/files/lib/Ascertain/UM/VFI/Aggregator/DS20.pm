package Ascertain::UM::VFI::Aggregator::DS20;

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
	my $ST_VOICE_INBOUND_ROAMERS_MO = FALSE;
	my $ST_VOICE_INBOUND_ROAMERS_MT = FALSE;
	my $ST_SMS_OTHER_INBOUND_ROAMERS_MO = FALSE;
	my $ST_SMS_OTHER_INBOUND_ROAMERS_MT = FALSE;
	my $ST_DATA_GPRS = FALSE;


	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

#Service Type == 00 && Service Code == 11  or 
#Service Type == 00 && Service Code == 12  or 
#Service Type == 00 && Service Code == 62  or 
#Service Type == 01 && Service Code == 26
	if (defined $d->{servicetype} and defined $d->{servicecode})
	{
		if 
		(
			($d->{servicetype} eq "00" and $d->{servicecode} =~ /1[12]|62/) or
			($d->{servicetype} eq "01" and $d->{servicecode} eq "26")
		)
		{
			$ST_VOICE = TRUE; push @serviceTypes, "ST_VOICE";
			$self->D_USAGE_TYPE("VOICE");        #AGGREGATOR KEY

			if (defined $d->{recordtype})
			{
				#if ($d->{recordtype} eq "20")
				if ($d->{recordtype} =~ /20|71/)
				{
					$ST_VOICE_INBOUND_ROAMERS_MO = TRUE; push @serviceTypes, "ST_VOICE_INBOUND_ROAMERS_MO";
				}
				elsif ($d->{recordtype} eq "30" && $d->{location_area_id} ne "99999")
				{
					$ST_VOICE_INBOUND_ROAMERS_MT = TRUE; push @serviceTypes, "ST_VOICE_INBOUND_ROAMERS_MT";
				}
			}
		}
		elsif ($d->{servicetype} eq "00")
		{
			if ($d->{servicecode} eq "22")
			{
				$ST_SMS_OTHER_INBOUND_ROAMERS_MO = TRUE; push @serviceTypes, "ST_SMS_OTHER_INBOUND_ROAMERS_MO";
				$self->D_USAGE_TYPE("SMS");        #AGGREGATOR KEY
			}
			elsif ($d->{servicecode} eq "21")
			{
				$ST_SMS_OTHER_INBOUND_ROAMERS_MT = TRUE; push @serviceTypes, "ST_SMS_OTHER_INBOUND_ROAMERS_MT";
				$self->D_USAGE_TYPE("SMS");        #AGGREGATOR KEY
			}
			elsif ($d->{servicecode} eq "70")
			{
				$ST_DATA_GPRS = TRUE; push @serviceTypes, "ST_DATA_GPRS";
				$self->D_USAGE_TYPE("DATA");        #AGGREGATOR KEY
			}
		}
	}


	# ---- TIMESLOT
	#2010-12-17 11:53:46
	my $startDateTime = (defined $d->{startdatetime}) ? $d->{startdatetime} : "";
	my $timeSlot = "20" . $startDateTime;
	$timeSlot =~ s/^(\d{10}).*/$1/;
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT
	my $revenue = (defined $d->{charge_sdr}) ? $d->{charge_sdr} : 0;
	$revenue =~ s/\D//g; # has an 'A' in it

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
