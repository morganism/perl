package Ascertain::UM::VFI::Aggregator::DS76;

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
	my $ST_ITC_VOICE = FALSE;
	my $ST_ITC_VOICE_IN = FALSE;
	my $ST_ITC_VOICE_OUT = FALSE;

	my $ST_ITC_SMS = FALSE;
	my $ST_ITC_SMS_IN = FALSE;
	my $ST_ITC_SMS_OUT = FALSE;

	my $ST_ITC_MMS = FALSE;
	my $ST_ITC_MMS_OUT = FALSE;
	my $ST_ITC_MMS_IN = FALSE;

	my $ST_UNIDENT = TRUE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

	$self->{debugger}("start");

	my $recordType = $d->{RecordType};

        #----------------- TIMESLOT --------------------
	my $startDate = (defined $d->{START_DATE}) ? $d->{START_DATE} : "";
	my $startTime = (defined $d->{START_TIME}) ? $d->{START_TIME} : "";
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

	
	my $volume = (defined $d->{VOLUME}) ? $d->{VOLUME} : 0;
	my $trafficType = (defined $d->{TRAFFIC_TYPE}) ? $d->{TRAFFIC_TYPE} : ""; 

	if ($trafficType eq "6") {

		$self->D_USAGE_TYPE("SMS");
		$ST_ITC_SMS = TRUE; push @serviceTypes, "ST_ITC_SMS";
		$ST_UNIDENT = FALSE;
		
		if (defined $d->{RECORD_TYPE} and $d->{RECORD_TYPE} eq "O") {
			$ST_ITC_SMS_OUT = TRUE; push @serviceTypes, "ST_ITC_SMS_OUT";
		}
		elsif (defined $d->{RECORD_TYPE} and $d->{RECORD_TYPE} eq "I") {
			$ST_ITC_SMS_IN = TRUE; push @serviceTypes, "ST_ITC_SMS_IN";
		}
	}
	elsif ($trafficType eq "7") {

		$self->D_USAGE_TYPE("MMS");
		$ST_ITC_MMS = TRUE; push @serviceTypes, "ST_ITC_MMS";
	
		if (defined $d->{RECORD_TYPE} and $d->{RECORD_TYPE} eq "O") {
			$ST_ITC_MMS_OUT = TRUE; push @serviceTypes, "ST_ITC_MMS_OUT";
		}
		elsif (defined $d->{RECORD_TYPE} and $d->{RECORD_TYPE} eq "I") {
			$ST_ITC_MMS_IN = TRUE; push @serviceTypes, "ST_ITC_MMS_IN";
		}
		$ST_UNIDENT = FALSE;

		$volume = $volume * 1024; # MMS volume in Kb (instead of bytes)
        }
	elsif ($trafficType ne "6" and defined $d->{MSCID} and $d->{MSCID} =~ /^MSS/ ) {

                $self->D_USAGE_TYPE("VOICE");
                $ST_ITC_VOICE = TRUE; push @serviceTypes, "ST_ITC_VOICE";
                $ST_UNIDENT = FALSE;

		if (defined $d->{RECORD_TYPE} and $d->{RECORD_TYPE} eq "O") {
			$ST_ITC_VOICE_OUT = TRUE; push @serviceTypes, "ST_ITC_VOICE_OUT";
		}
                elsif (defined $d->{RECORD_TYPE} and $d->{RECORD_TYPE} eq "I") {
			$ST_ITC_VOICE_IN = TRUE; push @serviceTypes, "ST_ITC_VOICE_IN";
		}
        }
		
	my $duration = (defined $d->{DURATION}) ? $d->{DURATION} : 0;
	my $value = (defined $d->{CHARGE}) ? $d->{CHARGE} : 0;

	# ---- FILL AGGREGATION DATA STRUCTURE
	push @serviceTypes, "ST_UNIDENT" if ($ST_UNIDENT); 
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => $duration,
			sum_bytes    => $volume,
			sum_value    => $value 
		}
	); # call the method in the parent class

	# ---- FILL AGGREGATION DATA STRUCTURE
}

1;
