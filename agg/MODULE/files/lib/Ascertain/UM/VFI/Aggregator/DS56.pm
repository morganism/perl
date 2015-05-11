package Ascertain::UM::VFI::Aggregator::DS56;

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
	#$self->D_SERVICE_TYPE(UNKNOWN);      #AGGREGATOR KEY
  $self->D_USAGE_TYPE("DATA");        #AGGREGATOR KEY
  #--- EVERYTHING ABOVE IS REQUIRED


	my $ST_UNIDENT = TRUE;
	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

	my $ST_DATA_GPRS = FALSE;
	my $ST_DATA_WAP = FALSE;
	
	my $ST_DATA_GPRS_1400 = FALSE;
        my $ST_DATA_WAP_1400 = FALSE;

	my $ST_DATA_GPRS_1499 = FALSE;
        my $ST_DATA_WAP_1499 = FALSE;

	my $ST_DATA_GPRS_OTHER = FALSE;
        my $ST_DATA_WAP_OTHER = FALSE;


        #----------------- RECORD TYPE --------------------
        my $recordType = $d->{ngmeRecordType};
        #----------------- RECORD TYPE --------------------

        if (not defined $recordType)
        {
                $self->{input_file_obj}->decrementAggregatedLineCount();
                return undef;
        }

	my $ratingGroup = "";

	if (defined $d->{ServCond_ratingGroup}) {
		$ratingGroup = $d->{ServCond_ratingGroup};
	}


	if ( $recordType eq "0" ) {

		if ( ($ratingGroup ne "1499") and
		     ($ratingGroup ne "1400") ) 
		{	

			if (defined $d->{accessPointNameNI})
			{
				if 
				(
					($d->{accessPointNameNI} ne "live.vodafone.com") and
					($d->{accessPointNameNI} ne "wap.vodafone.ie")
				)
				{
					$ST_DATA_GPRS = TRUE; push @serviceTypes, "ST_DATA_GPRS";
					$ST_UNIDENT = FALSE;
				}
				elsif 
				(
					($d->{accessPointNameNI} eq "live.vodafone.com") or
					($d->{accessPointNameNI} eq "wap.vodafone.ie")
				)
				{
					$ST_DATA_WAP = TRUE; push @serviceTypes, "ST_DATA_WAP";
					$ST_UNIDENT = FALSE;
				}
			}
		}
		else
		{
                        if (defined $d->{accessPointNameNI})
                        {
                                if
                                (
                                        ($d->{accessPointNameNI} ne "live.vodafone.com") and
                                        ($d->{accessPointNameNI} ne "wap.vodafone.ie")
                                )
                                {
					if ($ratingGroup eq "1400") 
					{
	                                        $ST_DATA_GPRS_1400 = TRUE; push @serviceTypes, "ST_DATA_GPRS_1400";
        	                                $ST_UNIDENT = FALSE;
					}
					else
					{
						$ST_DATA_GPRS_1499 = TRUE; push @serviceTypes, "ST_DATA_GPRS_1499";
                                                $ST_UNIDENT = FALSE;
					}
                                }
                                elsif
                                (
                                        ($d->{accessPointNameNI} eq "live.vodafone.com") or
                                        ($d->{accessPointNameNI} eq "wap.vodafone.ie")
                                )
                                {
					if ($ratingGroup eq "1400")
                                        {

 	                                       $ST_DATA_WAP_1400 = TRUE; push @serviceTypes, "ST_DATA_WAP_1400";
         	                               $ST_UNIDENT = FALSE;
					}
					else
                                        {
                                                $ST_DATA_GPRS_1499 = TRUE; push @serviceTypes, "ST_DATA_GPRS_1499";
                                                $ST_UNIDENT = FALSE;
                                        }

                                }
                        }
		}
	}


	# ---- TIMESLOT
	my $startDateTime;
	if (defined $d->{ServCond_timeOfFirstUsage}) 
	{
		$startDateTime = "20" . $d->{ServCond_timeOfFirstUsage};
	}
	else 
	{
		$startDateTime = "20" . $d->{recordOpeningTime};
	}

	my $timeSlot = $startDateTime;
	$timeSlot =~ s/^(\d{10}).*/$1/g;
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT


	my $volume = 0;
	if (defined $d->{ServCond_datavolumeFBCUplink} and defined $d->{ServCond_datavolumeFBCDownlink})
	{
		$volume = $d->{ServCond_datavolumeFBCUplink} + $d->{ServCond_datavolumeFBCDownlink};
	}
	push @serviceTypes, "ST_UNIDENT" if ($ST_UNIDENT);
	#--- EVERYTHING BELOW IS REQUIRED
	# ---- FILL AGGREGATION DATA STRUCTURE
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
