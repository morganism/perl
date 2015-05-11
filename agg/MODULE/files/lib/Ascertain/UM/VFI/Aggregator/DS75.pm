package Ascertain::UM::VFI::Aggregator::DS75;

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
	my $ST_ITC_MMS = FALSE;
	my $ST_ITC_MMS_OUT = FALSE;
	my $ST_ITC_MMS_IN = FALSE;
	my $ST_UNIDENT = TRUE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

	$self->{debugger}("start");

	my $recordType = $d->{RecordType};

        #----------------- TIMESLOT --------------------
	my $startDateTime = (defined $d->{SubmissionTime}) ? $d->{SubmissionTime} : "";
        my $timeSlot = $startDateTime;
	
	$timeSlot =~ s/^(\d{8}).*/$1/;
	$timeSlot = "20" . $timeSlot;

        unless ($timeSlot =~ m/\d{10}/)
        {
                $self->{debugger}("Invalid timeslot");
                $self->{timeslotError}{$recordType}++;
                $self->{unaggregateable}++;
                return undef;
        }
        $self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	#----------------- TIMESLOT --------------------

	$self->D_USAGE_TYPE("MMS");        #AGGREGATOR KEY

	# Business rules 

	if ($recordType eq "MM4Orecord" ) {
		
		$ST_ITC_MMS = TRUE; push @serviceTypes, "ST_ITC_MMS";	
		$ST_ITC_MMS_IN = TRUE; push @serviceTypes, "ST_ITC_MMS_IN";
		$ST_UNIDENT = FALSE;

   	}
	elsif ($recordType eq "MM4Rrecord" ) {

		$ST_ITC_MMS = TRUE; push @serviceTypes, "ST_ITC_MMS";
                $ST_ITC_MMS_OUT = TRUE; push @serviceTypes, "ST_ITC_MMS_OUT";
		$ST_UNIDENT = FALSE;
	}
	else {

		$ST_UNIDENT = TRUE;
	}
	

        my $volume = (defined $d->{MessageSize}) ? $d->{MessageSize} : 0;

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

1;
