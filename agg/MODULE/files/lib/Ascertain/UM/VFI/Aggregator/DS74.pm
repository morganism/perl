package Ascertain::UM::VFI::Aggregator::DS74;

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
	my $ST_ITC_SMS_IN = FALSE;

	my $ST_ITC_VOICE = FALSE;
	my $ST_ITC_VOICE_IN = FALSE;
	my $ST_ITC_VOICE_OUT = FALSE;
	
	my $ST_UNIDENT = TRUE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

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
	
	my $endBlock = $d->{LastBlock};

	if (defined $d->{InGroup} and $d->{InGroup} =~ /SMSIN/ ) {
		$self->D_USAGE_TYPE("SMS");        #AGGREGATOR KEY
		
	
		# Last 25 chars of each record is variable. (dependant on if record SMS or Non-SMS)
		# For SMS the IMSI is in the last field. 
		# e.g. 000000272017212869958END 0
		my $imsi = substr($endBlock, 0, 20); 
		$imsi+=0; # remove leading zeros
		$d->{IMSI} = $imsi;
		
		$ST_ITC_SMS_IN = TRUE; push @serviceTypes, "ST_ITC_SMS_IN";
		$ST_UNIDENT = FALSE;
   	}
	else {
		$self->D_USAGE_TYPE("VOICE");        #AGGREGATOR KEY

		# Last 25 chars of each record is variable. (dependant on if record SMS or Non-SMS)
                # For Non-SMS tariff class, bearer service code, & teleServiceCode in the last block
		# e.g. 0002BSCD00200TSCD00200END 001
		my $tariffClass = substr($endBlock, 0, 4);
		my $bearerSC = substr($endBlock, 11, 2);
		my $teleServiceCode = substr($endBlock, 20, 2);
		
		$d->{tariffClass} = $tariffClass;
		$d->{bearerSC} = $bearerSC;
		$d->{teleServiceCode} = $teleServiceCode;

		$ST_ITC_VOICE = TRUE; push @serviceTypes, "ST_ITC_VOICE";
                $ST_UNIDENT = FALSE;

		if (defined $d->{CallType} and $d->{CallType} eq "1" ) {
			$ST_ITC_VOICE_OUT = TRUE; push @serviceTypes, "ST_ITC_VOICE_OUT";
		}
		elsif (defined $d->{CallType} and $d->{CallType} eq "2" ) {
			$ST_ITC_VOICE_IN = TRUE; push @serviceTypes, "ST_ITC_VOICE_IN";
		}


		if ($self->isItcRouteValue($d->{InGroup},$d->{OutGroup}) eq "NOMATCH") {
			$self->addItcRouteValue($d->{InGroup},$d->{OutGroup});
		}
	}
	
    


    my $duration = (defined $d->{Duration}) ? $d->{Duration}/100 : 0;

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

1;
