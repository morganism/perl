package Ascertain::UM::VFI::Aggregator::DS93;

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
	$self->D_USAGE_TYPE(UNKNON);        #AGGREGATOR KEY
	$self->D_SERVICE_TYPE(UNKNOWN);      #AGGREGATOR KEY
	#--- EVERYTHING ABOVE IS REQUIRED

	my $ST_ALL = FALSE;
	my $ST_UNIDENT = FALSE;

	my $ST_VOICE = FALSE;
	my $ST_VOICE_FO = FALSE;
	my $ST_VOICE_FT = FALSE;
	my $ST_VOICE_INTL = FALSE;
	my $ST_VOICE_DOM = FALSE;
	my $ST_VOICE_SUSPENSE = FALSE;
	my $ST_VOICE_MT = FALSE;
	my $ST_VOICE_MT_INTL = FALSE;
	my $ST_VOICE_INTL_FREE = FALSE;
	my $ST_VOICE_PREMIUM = FALSE;
	my $ST_VOICE_PREMIUM_INTL = FALSE;
	my $ST_VOICE_INTERNET = FALSE;
	my $ST_VOICE_VOIP = FALSE;
	my $ST_VOICE_DQ = FALSE;
	my $ST_VOICE_LOW_CALL = FALSE;
	my $ST_VOICE_NGN = FALSE;
	my $ST_VOICE_PROMOTIONAL = FALSE;
	my $ST_VOICE_ANCILIARY = FALSE;
	my $ST_VOICE_INBOUND = FALSE;
	my $ST_SMS = FALSE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

    #----------------- TIMESLOT --------------------
	my $eventDate = (defined $d->{Event_Date}) ? $d->{Event_Date} : "";
	my $timeSlot = "";

        if ($eventDate =~ m;^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$;)
        {
                $timeSlot = sprintf "%4d%02d%02d%02d", $1,$2,$3,$4;
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

	my $classification = (defined $d->{Classification}) ? lc($d->{Classification}) : "";
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

	
	$self->specifySourceForAggRecords("ST_ALL",$provider);
	

	if ($classification ne "sms" and $classification ne "inbound services") {
		$ST_VOICE = TRUE; push @serviceTypes, "ST_VOICE";
		$self->specifySourceForAggRecords("ST_VOICE",$provider);

		$self->D_USAGE_TYPE("VOICE");

		if ($provider ne "C&W") {
			$ST_VOICE_FO = TRUE; push @serviceTypes, "ST_VOICE_FO";
			$self->specifySourceForAggRecords("ST_VOICE_FO",$provider);
		}
	}

	if ($provider eq "C&W" and $classification ne "sms") {
		$ST_VOICE_FT = TRUE; push @serviceTypes, "ST_VOICE_FT";
		$self->specifySourceForAggRecords("ST_VOICE_FT",$provider);
	}
	
	if ($classification =~ /international/) { 
		$ST_VOICE_INTL = TRUE; push @serviceTypes, "ST_VOICE_INTL";
		$self->specifySourceForAggRecords("ST_VOICE_INTL",$provider);
	}

    if ($classification eq "national" or $classification eq "_national") {
        $ST_VOICE_DOM = TRUE; push @serviceTypes, "ST_VOICE_DOM";
		$self->specifySourceForAggRecords("ST_VOICE_DOM",$provider);
    }

	if ($ST_VOICE and $d->{suspense_code} ne "0") {
        $ST_VOICE_SUSPENSE = TRUE; push @serviceTypes, "ST_VOICE_SUSPENSE";
		$self->specifySourceForAggRecords("ST_VOICE_SUSPENSE",$provider);
    }

	if ($classification eq "mobile" or $classification eq "international mobile") {
        $ST_VOICE_MT = TRUE; push @serviceTypes, "ST_VOICE_MT";
		$self->specifySourceForAggRecords("ST_VOICE_MT",$provider);
    }

	if ($classification eq "international mobile") {
        $ST_VOICE_MT_INTL = TRUE; push @serviceTypes, "ST_VOICE_MT_INTL";
		$self->specifySourceForAggRecords("ST_VOICE_MT_INTL",$provider);
    }

	if ($classification eq "international free") {
        $ST_VOICE_INTL_FREE = TRUE; push @serviceTypes, "ST_VOICE_INTL_FREE";
		$self->specifySourceForAggRecords("ST_VOICE_INTL_FREE",$provider);
    }

	if ($classification eq "premium" or $classification eq "international premium" or $classification eq "satellite") {
        $ST_VOICE_PREMIUM = TRUE; push @serviceTypes, "ST_VOICE_PREMIUM";
		$self->specifySourceForAggRecords("ST_VOICE_PREMIUM",$provider);
    }

	if ($classification eq "international premium" or $classification eq "satellite") {
        $ST_VOICE_PREMIUM_INTL = TRUE; push @serviceTypes, "ST_VOICE_PREMIUM_INTL";
		$self->specifySourceForAggRecords("ST_VOICE_PREMIUM_INTL",$provider);
    }

	if ($classification eq "perlico internet" or $classification eq "eircom internet") {
        $ST_VOICE_INTERNET = TRUE; push @serviceTypes, "ST_VOICE_INTERNET";
		$self->specifySourceForAggRecords("ST_VOICE_INTERNET",$provider);
    }

	if ($classification eq "voip") {
        $ST_VOICE_VOIP = TRUE; push @serviceTypes, "ST_VOICE_VOIP";
		$self->specifySourceForAggRecords("ST_VOICE_VOIP",$provider);
    }

	if ($classification eq "directory enquiry calls") {
        $ST_VOICE_DQ = TRUE; push @serviceTypes, "ST_VOICE_DQ";
		$self->specifySourceForAggRecords("ST_VOICE_DQ",$provider);
    }

	if ($classification eq "low-call") {
        $ST_VOICE_LOW_CALL = TRUE; push @serviceTypes, "ST_VOICE_LOW_CALL";
		$self->specifySourceForAggRecords("ST_VOICE_LOW_CALL",$provider);
    }

	if ($classification eq "ngn") {
        $ST_VOICE_NGN = TRUE; push @serviceTypes, "ST_VOICE_NGN";
		$self->specifySourceForAggRecords("ST_VOICE_NGN",$provider);
    }
	
	if ($classification eq "promotional") {
        $ST_VOICE_PROMOTIONAL = TRUE; push @serviceTypes, "ST_VOICE_PROMOTIONAL";
		$self->specifySourceForAggRecords("ST_VOICE_PROMOTIONAL",$provider);
    }
	
	if ($classification eq "inbound service") {
        $ST_VOICE_INBOUND = TRUE; push @serviceTypes, "ST_VOICE_INBOUND";
		$self->specifySourceForAggRecords("ST_VOICE_INBOUND",$provider);
    }

	if ($classification eq "sms") {
        $ST_SMS = TRUE; push @serviceTypes, "ST_SMS";
		$self->specifySourceForAggRecords("ST_SMS",$provider);
		$self->D_USAGE_TYPE("SMS");
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
