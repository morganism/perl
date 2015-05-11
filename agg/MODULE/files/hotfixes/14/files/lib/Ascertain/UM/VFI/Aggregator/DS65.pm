package Ascertain::UM::VFI::Aggregator::DS65;

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
  $self->D_USAGE_TYPE("SMS");        #AGGREGATOR KEY
  #--- EVERYTHING ABOVE IS REQUIRED

	my $ST_ALL = FALSE;
	my $ST_SMS_ROAMING_MO_PREPAID = FALSE;
	my $ST_SMS_PREMIUM_MO_PREPAID = FALSE;
	my $ST_SMS_PREMIUM_MT_PREPAID = FALSE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";
	if (defined $d->{CCN_TrafficCase} and $d->{CCN_TrafficCase} eq "20")
	{
#CCN_TrafficCase = .20. AND CCN_OriginatingLocationInfo does not begin with 353 AND CCN_ExtInt1= .0. in ccn*sms* files
		if 
		(
			defined $d->{CCN_OriginatingLocationInfo} and $d->{CCN_OriginatingLocationInfo} !~ /^353/ and
			defined $d->{CCN_ExtInt1} and $d->{CCN_ExtInt1} eq "0"
		)
		{
			$ST_SMS_ROAMING_MO_PREPAID = TRUE; push @serviceTypes, "ST_SMS_ROAMING_MO_PREPAID";
		}

#CCN_TrafficCase = .20. AND CCN_CalledPartyNumber begins with 1 or 5 and length = 5 in ccn*sms* files
		if (defined $d->{CCN_CalledPartyNumber} and $d->{CCN_CalledPartyNumber} =~ /^[15]\d{4}$/)
		{
			$ST_SMS_PREMIUM_MO_PREPAID = TRUE; push @serviceTypes, "ST_SMS_PREMIUM_MO_PREPAID";
		}
	}
#CCN_TrafficCase = .21. AND CCN_CalledPartyNumber begins with 1 or 5 and length = 5 in ccn*sms* files
	elsif 
	(
		defined $d->{CCN_TrafficCase} and $d->{CCN_TrafficCase} eq "21" and
		defined $d->{CCN_CallingPartyNumber} and $d->{CCN_CallingPartyNumber} =~ /^[15]\d{4}$/
	)
	{
			$ST_SMS_PREMIUM_MT_PREPAID = TRUE; push @serviceTypes, "ST_SMS_PREMIUM_MT_PREPAID";
	}


	# ---- TIMESLOT
#CCN_TriggerTime                                  [2011-01-21 05:34:34]
	my $startDate = (defined $d->{CCN_TriggerTime}) ? $d->{CCN_TriggerTime} : "";
	$startDate =~ s/[-\s:]//g;
	my $timeSlot = $startDate;
	$timeSlot =~ s/^(\d{10}).*/$1/;
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}
	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT



#CCN_AccountValueBefore - CCN_AccountValueAfter
	my $accountValueBefore = (defined $d->{CCN_AccountValueBefore}) ? $d->{CCN_AccountValueBefore} : 0;
	my $accountValueAfter = (defined $d->{CCN_AccountValueAfter}) ? $d->{CCN_AccountValueAfter} : 0;

	my $revenue = $accountValueBefore - $accountValueAfter;

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
