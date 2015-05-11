package Ascertain::UM::VFI::Aggregator::DS72;

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
	my $ST_DATA_GPRS = FALSE;
	my $ST_DATA_WAP = FALSE;
	my $ST_DATA_2G = FALSE;
	my $ST_DATA_3G = FALSE;
	my $ST_DATA_4G = FALSE;
	
	my $ST_DATA_2G_INBOUND_ROAMERS = FALSE;
	my $ST_DATA_2G_DOMESTIC = FALSE;
 	my $ST_DATA_3G_INBOUND_ROAMERS = FALSE;
	my $ST_DATA_3G_DOMESTIC = FALSE;
	my $ST_DATA_PARTNERS = FALSE;

	my $ST_UNIDENT = TRUE;

	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

	$self->specifySourceInit();

	$self->D_USAGE_TYPE("DATA");        #AGGREGATOR KEY

	#----------------- RECORD TYPE --------------------
	my $recordType = $d->{recordType};
	#----------------- RECORD TYPE --------------------
	if (not defined $recordType)
	{
		$self->{input_file_obj}->decrementAggregatedLineCount();
		return undef;
	}
	
        #----------------- TIMESLOT --------------------
	if (defined $d->{recordOpeningTime})
	{
		$timeSlot = $self->getTimeslot($d->{recordOpeningTime});
		$self->D_TIMESLOT($timeSlot) if (defined $timeSlot);
	}
	else
        {
                 $self->{timeslotError}{$recordType}++;
                 $self->{unaggregateable}++;
                 return undef;
        }
	#----------------- TIMESLOT --------------------

	my $subscriberIMSI = $self->decodeIMSI($d->{servedIMSI});

	# Business rules
        if (defined $d->{accessPointNameNI} and $d->{accessPointNameNI} !~ /live.vodafone.com|wap.vodafone.ie/)
        {
                $ST_DATA_GPRS = TRUE; push @serviceTypes, "ST_DATA_GPRS";
        }
        else
        {
                $ST_DATA_WAP = TRUE; push @serviceTypes, "ST_DATA_WAP";
        }

        if (defined $d->{systemType} and $d->{systemType} =~ /[^E]UTRAN/ ) # 3G
        {
                $ST_DATA_3G = TRUE; push @serviceTypes, "ST_DATA_3G";
                $ST_UNIDENT = FALSE;

		if (defined $subscriberIMSI and $subscriberIMSI =~ /^27201/ ) {
			$ST_DATA_3G_DOMESTIC = TRUE; push @serviceTypes, "ST_DATA_3G_DOMESTIC";
		}
		else {
			$ST_DATA_3G_INBOUND_ROAMERS = TRUE; push @serviceTypes, "ST_DATA_3G_INBOUND_ROAMERS";
		}
        }
        elsif (defined $d->{systemType} and $d->{systemType} =~ /GERAN/  ) # 2G
        {
                $ST_DATA_2G = TRUE; push @serviceTypes, "ST_DATA_2G";
                $ST_UNIDENT = FALSE;

		if (defined $subscriberIMSI and $subscriberIMSI =~ /^27201/ ) {
                        $ST_DATA_2G_DOMESTIC = TRUE; push @serviceTypes, "ST_DATA_2G_DOMESTIC";
                }
                else {
                        $ST_DATA_2G_INBOUND_ROAMERS = TRUE; push @serviceTypes, "ST_DATA_2G_INBOUND_ROAMERS";
                }
        }
        # 4G traffic should not occur in SGSN but will leave rule here just in case
        elsif (defined $d->{systemType} and $d->{systemType} =~ /EUTRAN/ )  # 4G
        {
                $ST_DATA_4G = TRUE; push @serviceTypes, "ST_DATA_4G";
                $ST_UNIDENT = FALSE;
        }
	elsif (!defined $d->{systemType} or $d->{systemType} =~ //  ) # 2G
        {
                $ST_DATA_2G = TRUE; push @serviceTypes, "ST_DATA_2G";
                $ST_UNIDENT = FALSE;
	
		if (defined $subscriberIMSI and $subscriberIMSI =~ /^27201/ ) {
                        $ST_DATA_2G_DOMESTIC = TRUE; push @serviceTypes, "ST_DATA_2G_DOMESTIC";
                }
                else {
                        $ST_DATA_2G_INBOUND_ROAMERS = TRUE; push @serviceTypes, "ST_DATA_2G_INBOUND_ROAMERS";
                }
        }

	if (    $self->isPartner($subscriberIMSI) ne 0 )
	{
		$ST_DATA_PARTNERS = TRUE; push @serviceTypes, "ST_DATA_PARTNERS";
		$self->specifySourceForAggRecords("ST_DATA_PARTNERS",$self->isPartner($subscriberIMSI));
	}


	my $duration = (defined $d->{duration}) ? $d->{duration} : 0;
	my $upVolume = (defined $d->{dataVolumeGPRSUplink}) ? $d->{dataVolumeGPRSUplink} : 0;
	my $downVolume = (defined $d->{dataVolumeGPRSDownlink}) ? $d->{dataVolumeGPRSDownlink} : 0;

	my $volume = $upVolume + $downVolume;

	# ---- FILL AGGREGATION DATA STRUCTURE
	push @serviceTypes, "ST_UNIDENT" if ($ST_UNIDENT); 
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => $duration,
			sum_bytes    => $volume,
			sum_value    => 0 
		}
	); # call the method in the parent class

	# ---- FILL AGGREGATION DATA STRUCTURE
}

sub getTimeslot
{
        my $self = shift;
        my $datetime = shift;

	my $d = "20" . $datetime;
        $d =~ s/\s//g;

        return $d if ($d =~ s/^(\d{10}).*/$1/); # parse success
        return FALSE; # parse failed
}

1;
