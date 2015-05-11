package Ascertain::UM::VFI::Aggregator::DS47;

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

	# reset vars
	my $ST_ALL = FALSE;
	my $ST_UNIDENT = TRUE;
	my $ST_MMS = FALSE;
	my $ST_MMS_PREPAID = FALSE;
	my $ST_MMS_POSTPAID = FALSE;
	my $ST_MMS_PREPAID_ARP = FALSE;
        my $ST_MMS_POSTPAID_ARP = FALSE;
	my $ST_MMS_PREPAID_HOME_MO = FALSE;
	my $ST_MMS_PREPAID_HOME_MO_ARP = FALSE;
	my $ST_MMS_POSTPAID_HOME_MO = FALSE;
	my $ST_MMS_POSTPAID_HOME_MO_ARP = FALSE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";
	$ST_MMS = TRUE; push @serviceTypes, "ST_MMS";
	$self->D_USAGE_TYPE("MMS");        #AGGREGATOR KEY


	if ( defined $d->{payer_prepaid_flag} and $d->{payer_prepaid_flag} eq "1" ) {
		if (not defined $d->{cost_unit} or $d->{cost_unit} eq "NULL" ) {
			$ST_MMS_PREPAID  = TRUE; push @serviceTypes, "ST_MMS_PREPAID";
		}
		else {
			$ST_MMS_PREPAID_ARP  = TRUE; push @serviceTypes, "ST_MMS_PREPAID_ARP";
		}
	}
	else {
		if (not defined $d->{cost_unit} or $d->{cost_unit} eq "NULL" ) {
			$ST_MMS_POSTPAID = TRUE; push @serviceTypes, "ST_MMS_POSTPAID";
		}
		else {
			$ST_MMS_POSTPAID_ARP = TRUE; push @serviceTypes, "ST_MMS_POSTPAID_ARP";
		}
	}


	if (    defined $d->{origin_host} and $d->{origin_host} eq "mms.vodafone.ie" 
	    and defined $d->{payer_prepaid_flag} and $d->{payer_prepaid_flag} eq "1"
	    and defined $d->{result_code} and $d->{result_code} eq "128" )
	{
		$ST_UNIDENT = FALSE;
     
        if (not defined $d->{cost_unit} or $d->{cost_unit} eq "NULL" ) {
            $ST_MMS_PREPAID_HOME_MO = TRUE; push @serviceTypes, "ST_MMS_PREPAID_HOME_MO";
        }
        else {
            $ST_MMS_PREPAID_HOME_MO_ARP = TRUE; push @serviceTypes, "ST_MMS_PREPAID_HOME_MO_ARP";
        }
	}


    if (    defined $d->{origin_host} and $d->{origin_host} eq "mms.vodafone.ie"
        and (not defined $d->{payer_prepaid_flag} or $d->{payer_prepaid_flag} eq "0" )
        and defined $d->{result_code} and $d->{result_code} eq "128" )
    {
        $ST_UNIDENT = FALSE;

        if (not defined $d->{cost_unit} or $d->{cost_unit} eq "NULL" ) {
            $ST_MMS_POSTPAID_HOME_MO = TRUE; push @serviceTypes, "ST_MMS_POSTPAID_HOME_MO";
        }
        else {
            $ST_MMS_POSTPAID_HOME_MO_ARP = TRUE; push @serviceTypes, "ST_MMS_POSTPAID_HOME_MO_ARP";
        }
    }


	# 2011-01-20 14:50:05
	my $startDate = (defined $d->{submission_time}) ? $d->{submission_time} : "";
	my $timeSlot = $startDate;
	$timeSlot =~ s/^(\d{10}).*/$1/;

	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT

	my $volume = (defined $d->{message_size}) ? $d->{message_size} : 0;


	#--- EVERYTHING BELOW IS REQUIRED
	# ---- FILL AGGREGATION DATA STRUCTURE
  	push @serviceTypes, "ST_UNIDENT" if ($ST_UNIDENT);
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
