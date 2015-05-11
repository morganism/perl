package Ascertain::UM::VFI::Aggregator::DS99;

#------------------------------------------------------------------------------
# This is for contructing this as a subclass of Aggregator
#------------------------------------------------------------------------------
use Data::Dumper;
use Date::Calc qw/Delta_Days/;

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
	my $ST_UNIDENT = FALSE;

	my $ST_VOICE = FALSE;
	my $ST_SUSPENSE = FALSE;
	my $ST_VOICE_SUSPENSE = FALSE;
	my $ST_VOICE_AGED = FALSE;
	my $ST_VOICE_EXPIRING = FALSE;
	my $ST_OTHER_SUSPENSE = FALSE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

    #----------------- TIMESLOT --------------------
	my $edrFileNameDate =  $self->{input_file_obj}->getEdrFileName(); 
	# Extract_CDR_UNBILLED_YYYYMMDDHHSS.txt.suspenseHist

	my $timeslot = "";
	if ($edrFileNameDate =~ m;^Daily_Suspense_(\d{10}).*;)
	{
		$timeSlot = sprintf "%10d", $1;
	}

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

	my $classification = (defined $d->{Classification}) ? $d->{Classification} : "";
	my $provider = "";

	$self->specifySourceInit();

        if ($d->{File_Name} =~ /PERLICO_DAILY.*/ or $d->{Provider} eq "BT") {
                $provider = "BT";
        }
        elsif ($d->{File_Name} =~ /RAW.XB.*/ or $d->{Provider} eq "EI") {
        $provider = "Eircom";
    }
        elsif ($d->{File_Name} =~ /VODAFONE_ES_D.*/ or $d->{Provider} eq "VOL") {
        $provider = "VOIP";
    }
        elsif ($d->{File_Name} =~ /C08586_Vodafone Ireland Ltd.*/ or $d->{Provider} eq "CW") {
        $provider = "C&W";
    }
        elsif ($d->{File_Name} =~ /EircomCDRWLR.*/ or $d->{Provider} eq "EIA") {
        $provider = "Eircom WLR";
    }
        elsif ($d->{File_Name} =~ /BTCDRWLR.*/ or $d->{Provider} eq "BTA") {
        $provider = "BT WLR";
    }
        else {
                $provider = "Unknown";
        }

	
	$ST_SUSPENSE = TRUE; push @serviceTypes, "ST_SUSPENSE";
	$self->specifySourceForAggRecords("ST_ALL",$provider);
	$self->specifySourceForAggRecords("ST_SUSPENSE",$provider);


	if ($classification ne "SMS" and $classification ne "Inbound Service" ) {
		$ST_VOICE_SUSPENSE = TRUE; push @serviceTypes, "ST_VOICE_SUSPENSE";
		$ST_VOICE = TRUE; push @serviceTypes, "ST_VOICE";
		$self->D_USAGE_TYPE("VOICE");
		$self->specifySourceForAggRecords("ST_VOICE_SUSPENSE",$provider);
		$self->specifySourceForAggRecords("ST_VOICE",$provider);
	}
	else {
	        $ST_OTHER_SUSPENSE = TRUE; push @serviceTypes, "ST_OTHER_SUSPENSE";
                $self->specifySourceForAggRecords("ST_OTHER_SUSPENSE",$provider);

                if ($classification ne "SMS") {
                        $self->D_USAGE_TYPE("SMS");
                }
                else {
                        $self->D_USAGE_TYPE("VOICE");
                }
	}

	# Aged and Expiring Service types
    if ($ST_VOICE and (defined $self->{parameters}->{aged_days} or defined  $self->{parameters}->{expired_days})) {
		# Calculate date difference
	    my $eventDate = (defined $d->{Event_Date}) ? $d->{Event_Date} : "";
		my @eventDay = [];

	
        if ($eventDate =~ m;^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$;)
        {
		@eventDay = ($1, $2, $3);
        }

		my @batchDay;
	    if ($edrFileNameDate =~ m;^Daily_Suspense_(\d{4})(\d{2})(\d{2}).*;)
    	{
        	@batchDay = ($1, $2, $3);
    	}
	
		my $batchDayArrSize = @batchDay;
		my $eventDayArrSize = @eventDay;

		# If dates correct found and days diff are more then the parameter values
		if ($eventDayArrSize == 3 and $batchDayArrSize == 3) {
			
			my $days_diff = Delta_Days( @eventDay, @batchDay );
			if ($days_diff >= $self->{parameters}->{aged_days}->{value} ) {
				$ST_VOICE_AGED = TRUE; push @serviceTypes, "ST_VOICE_AGED";
 		        $self->specifySourceForAggRecords("ST_VOICE_AGED",$provider);
			}

			if ($days_diff >= $self->{parameters}->{expired_days}->{value} ) {
                $ST_VOICE_EXPIRING = TRUE; push @serviceTypes, "ST_VOICE_EXPIRING";
                $self->specifySourceForAggRecords("ST_VOICE_EXPIRING",$provider);
            }
		}
    }

	my $duration = (defined $d->{duration_secs}) ? $d->{duration_secs} : 0;
	my $value = (defined $d->{charge_price_cent}) ? $d->{charge_price_cent} : 0;

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
