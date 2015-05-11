package Ascertain::UM::VFI::Aggregator::DS73;

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
use constant FALSE => 0;
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
	my $timeSlot = "1999011401";
	$self->D_TIMESLOT($timeSlot);        #AGGREGATOR KEY
	$self->D_USAGE_TYPE(UNKNOWN);        #AGGREGATOR KEY
	$self->D_SERVICE_TYPE(UNKNOWN);      #AGGREGATOR KEY
	#--- EVERYTHING ABOVE IS REQUIRED

	my $ST_ALL = FALSE;
	my $ST_ITC_SMS_OUT = FALSE;
	my $ST_ITC_SMS_OUT_O2 = FALSE;
	my $ST_ITC_SMS_OUT_METEOR = FALSE;
	my $ST_ITC_SMS_OUT_HUTCHINSON = FALSE;
	my $ST_ITC_SMS_OUT_TESCO = FALSE;
	my $ST_ITC_SMS_OUT_POSTFONE = FALSE;
	my $ST_ITC_SMS_OUT_JUSTMOBILE = FALSE;
	my $ST_ITC_SMS_OUT_LYCA = FALSE;
	my $ST_ITC_SMS_OUT_OTHER_DEST = FALSE;
	my $ST_UNIDENT = TRUE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

	$self->D_USAGE_TYPE("SMS");        #AGGREGATOR KEY

	$self->{debugger}("start");

        #----------------- TIMESLOT --------------------
	my $startDateTime = (defined $d->{StartDateTime}) ? $d->{StartDateTime} : "";
        my $timeSlot = $startDateTime;
	$timeSlot =~ s/^(\d{10}).*/$1/;

        unless ($timeSlot =~ m/\d{10}/)
        {
                $self->{debugger}("Invalid timeslot");
                $self->{timeslotError}{"ALL"}++;
                $self->{unaggregateable}++;
                return undef;
        }
        $self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	#----------------- TIMESLOT --------------------


	# Business rules 
	
 	if (defined $d->{CallType} and $d->{CallType} eq "1") {
	
		$ST_ITC_SMS_OUT = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT";
		$ST_UNIDENT = FALSE;
	
		# These are not strictly required but will leave them here for now
		if (defined $d->{CalledPartyNumber} and $d->{CalledPartyNumber} =~ /^BT/) 
		{
			$ST_ITC_SMS_OUT_O2 = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_O2";
		}
		elsif (defined $d->{CalledPartyNumber} and $d->{CalledPartyNumber} =~ /^ME/)
                {
                        $ST_ITC_SMS_OUT_METEOR = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_METEOR";
                }
		elsif (defined $d->{CalledPartyNumber} and $d->{CalledPartyNumber} =~ /^HU/)
                {
                        $ST_ITC_SMS_OUT_HUTCHINSON = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_HUTCHINSON";
                }
		elsif (defined $d->{CalledPartyNumber} and $d->{CalledPartyNumber} =~ /^TE/)
                {
                        $ST_ITC_SMS_OUT_TESCO = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_TESCO";
                }
		elsif (defined $d->{CalledPartyNumber} and $d->{CalledPartyNumber} =~ /^AP/)
                {
                        $ST_ITC_SMS_OUT_POSTFONE = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_POSTFONE";
                }
		elsif (defined $d->{CalledPartyNumber} and $d->{CalledPartyNumber} =~ /^JM/)
                {
                        $ST_ITC_SMS_OUT_JUSTMOBILE = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_JUSTMOBILE";
                }
		elsif (defined $d->{CalledPartyNumber} and $d->{CalledPartyNumber} =~ /^LY/)
                {
                        $ST_ITC_SMS_OUT_LYCA = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_LYCA";
                }
		else {
			$ST_ITC_SMS_OUT_OTHER_DEST = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT_OTHER_DEST";
		}
	}



	# ---- FILL AGGREGATION DATA STRUCTURE
	push @serviceTypes, "ST_UNIDENT" if ($ST_UNIDENT); 
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => 0,
			sum_bytes    => 0,
			sum_value    => 0 
		}
	); # call the method in the parent class

	# ---- FILL AGGREGATION DATA STRUCTURE
}

1;
