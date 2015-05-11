package Ascertain::UM::VFI::Aggregator::DS90;

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
	$self->D_USAGE_TYPE("VOICE");        #AGGREGATOR KEY
	$self->D_SERVICE_TYPE(UNKNOWN);      #AGGREGATOR KEY
	#--- EVERYTHING ABOVE IS REQUIRED

	my $ST_ALL = FALSE;
	my $ST_VOICE = FALSE;
	my $ST_VOICE_FO = FALSE;
	my $ST_VOICE_INTL = FALSE;
	my $ST_VOICE_DOM = FALSE;
	my $ST_UNIDENT = TRUE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

    #----------------- TIMESLOT --------------------
	my $startDate = (defined $d->{CALLDATE}) ? $d->{CALLDATE} : "";
	my $startTime = (defined $d->{CALLTIME}) ? $d->{CALLTIME} : "";
    my $timeSlot = $startDate . $startTime;
	
	$timeSlot =~ s/^(\d{10}).*/$1/;

    unless ($timeSlot =~ m/\d{10}/)
    {
        $self->{debugger}("Invalid timeslot");
        $self->{timeslotError}{$recordType}++;
        $self->{unaggregateable}++;
        return undef;
    }
    $self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	#----------------- TIMESLOT --------------------

	$ST_VOICE = TRUE; push @serviceTypes, "ST_VOICE";

	# TODO: may need to restrict the below using cosdesc or gemdesc fields
	$ST_VOICE_FO = TRUE; push @serviceTypes, "ST_VOICE_FO";
	$ST_UNIDENT = FALSE;

	if (defined $d->{TERMNO} and $d->{TERMNO} =~ /^00/ and $d->{TERMNO} !~ /^00353/ ) {
		$ST_VOICE_INTL = TRUE; push @serviceTypes, "ST_VOICE_INTL";
	}
	else {
		$ST_VOICE_DOM = TRUE; push @serviceTypes, "ST_VOICE_DOM";
	}

	my $duration = (defined $d->{CALLDUR}) ? $d->{CALLDUR} : 0;
	my $value = (defined $d->{COS}) ? $d->{COS} : 0;

	# ---- FILL AGGREGATION DATA STRUCTURE
	push @serviceTypes, "ST_UNIDENT" if ($ST_UNIDENT); 
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => $duration,
			sum_bytes    => 0,
			sum_value    => $value 
		}
	); # call the method in the parent class

	# ---- FILL AGGREGATION DATA STRUCTURE
}

1;
