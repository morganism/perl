package Ascertain::UM::VFI::Aggregator::DS94;

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
	my $ST_UNIDENT = FALSE;
	my $ST_DISCARDED = FALSE;
	my $ST_VOICE_DISCARDED = FALSE;
	my $ST_OTHER_DISCARDED = FALSE;

	$self->specifySourceInit();

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

        #----------------- TIMESLOT --------------------
        my $edrFileNameDate =  $self->{input_file_obj}->getEdrFileName();

        my $timeslot = "";
        if ($edrFileNameDate =~ m;^MonthlySuspenseData_(\d{10}).*;)
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


	$ST_DISCARDED = TRUE; push @serviceTypes, "ST_DISCARDED";
	$self->specifySourceForAggRecords("ST_DISCARDED",$provider);
	$self->specifySourceForAggRecords("ST_ALL",$provider);

	if ($classification ne "SMS" and $classification ne "Inbound Service") {
		$ST_VOICE_DISCARDED = TRUE; push @serviceTypes, "ST_VOICE_DISCARDED";
		$self->specifySourceForAggRecords("ST_VOICE_DISCARDED",$provider);
		$self->D_USAGE_TYPE("VOICE");
	}
	else {
		$ST_OTHER_DISCARDED = TRUE; push @serviceTypes, "ST_OTHER_DISCARDED";
                $self->specifySourceForAggRecords("ST_OTHER_DISCARDED",$provider);
		if ($classification eq "SMS") {
                	$self->D_USAGE_TYPE("SMS");
		}
		else {
			$self->D_USAGE_TYPE("VOICE");
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
