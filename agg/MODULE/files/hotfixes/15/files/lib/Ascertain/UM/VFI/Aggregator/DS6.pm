package Ascertain::UM::VFI::Aggregator::DS6;

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
	#$self->D_TIMESLOT("1999011401");          #AGGREGATOR KEY
	#$self->D_USAGE_TYPE(UNKNOWN);        #AGGREGATOR KEY
	#$self->D_SERVICE_TYPE(UNKNOWN);      #AGGREGATOR KEY
	#--- EVERYTHING ABOVE IS REQUIRED


	# reset vars
	my $ST_ALL = FALSE;
	my $ST_VOICE = FALSE;
	my $ST_VOICE_POSTPAID = FALSE;
	my $ST_VOICE_POSTPAID_HOME = FALSE;
	my $ST_VOICE_POSTPAID_HOME_MO = FALSE;
	my $ST_VOICE_POSTPAID_HOME_CALL_FWD = FALSE;
	my $ST_VOICE_PREPAID = FALSE;
	my $ST_VOICE_PREPAID_HOME = FALSE;
	my $ST_VOICE_PREPAID_HOME_MO = FALSE;
	my $ST_VOICE_PREPAID_HOME_CALL_FWD = FALSE;
	my $ST_VOICE_OUTBOUND_ROAMERS_MO = FALSE;
	my $ST_VOICE_OUTBOUND_ROAMERS_MT = FALSE;
	my $ST_VOICE_INBOUND_ROAMERS_MO = FALSE;
	my $ST_VOICE_INBOUND_ROAMERS_MT = FALSE;
	my $ST_VOICE_INTERCONNECT = FALSE;
	my $ST_SMS = FALSE;
	my $ST_SMS_HOME = FALSE;
	my $ST_SMS_HOME_MO = FALSE;
	my $ST_SMS_HOME_MT = FALSE;
	my $ST_SMS_VODAFONE = FALSE;
	my $ST_SMS_O2 = FALSE;
	my $ST_SMS_METEOR = FALSE;
	my $ST_SMS_HUTCHINSON = FALSE;
	my $ST_SMS_TESCO = FALSE;
	my $ST_SMS_POSTFONE = FALSE;
	my $ST_SMS_JUSTMOBILE = FALSE;
	my $ST_SMS_OTHER_DEST = FALSE;
	my $ST_SMS_PREMIUM = FALSE;
	my $ST_SMS_PREPAID = FALSE;
	my $ST_SMS_OTHER_INBOUND_ROAMERS_MO = FALSE;
	my $ST_SMS_OTHER_INBOUND_ROAMERS_MT = FALSE;
	my $ST_SMS_OTHER_OUTBOUND_ROAMERS_MO = FALSE;
	my $ST_SMS_OTHER_OUTBOUND_ROAMERS_MT = FALSE;
	my $ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MO = FALSE;
	my $ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MT = FALSE;
	my $ST_SMS_ROAMING_MO_PREPAID = FALSE;
	my $ST_SMS_PREMIUM_MO_PREPAID = FALSE;
	my $ST_SMS_PREMIUM_MT_PREPAID = FALSE;
	my $ST_MMS = FALSE;
	my $ST_MMS_POSTPAID = FALSE;
	my $ST_MMS_POSTPAID_HOME = FALSE;
	my $ST_MMS_POSTPAID_HOME_MO = FALSE;
	my $ST_MMS_PREPAID = FALSE;
	my $ST_MMS_PREPAID_HOME = FALSE;
	my $ST_MMS_PREPAID_HOME_MO = FALSE;
	my $ST_MMS_OTHER = FALSE;
	my $ST_DATA = FALSE;
	my $ST_DATA_GPRS = FALSE;
	my $ST_DATA_WAP = FALSE;
	my $ST_DATA_GPRS_PREPAID = FALSE;
	my $ST_DATA_GPRS_POSTPAID = FALSE;
	my $ST_DATA_WAP_PREPAID = FALSE;
	my $ST_DATA_WAP_POSTPAID = FALSE;
	my $ST_DATA_GPRS_PREPAID_STRIP = FALSE;
	my $ST_DATA_GPRS_POSTPAID_STRIP = FALSE;
	my $ST_DATA_WAP_PREPAID_STRIP = FALSE;
	my $ST_DATA_WAP_POSTPAID_STRIP = FALSE;
	my $ST_CONTENT = FALSE;
	my $ST_CONTENT_POSTPAID = FALSE;
	my $ST_CONTENT_PREPAID = FALSE;
	my $ST_VOICE_ROAMERS = FALSE;
	my $ST_VOICE_OTHER_INBOUND_ROAMERS = FALSE;
	my $ST_VOICE_OTHER_OUTBOUND_ROAMERS = FALSE;
	my $ST_UNIDENT = TRUE;


	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";


	# ----- PREDEFINE variables used in data structure
	my $usageType     = UNKNOWN;
	my $serviceType   = UNKNOWN;
	my $subsType      = "POST"; # always POST as we are processing ICCS data, which is postpaid by definition
	my $callDirection = UNKNOWN;
	my $roaming       = UNKNOWN;
	# ----- PREDEFINE variables used in data structure

	# ---- FIRST determine base usage type
	# common var # one of: 21,22,81,82,83,84,86,88,89
	if (defined $d->{CALL_SERVICE_CODE})
	{
		if ($d->{CALL_SERVICE_CODE} =~ /^2[12]|8[1234689]$/)
		{
			$ST_SMS = TRUE; push @serviceTypes, "ST_SMS";
			$ST_UNIDENT = FALSE;
		}
		#elsif ($d->{CALL_SERVICE_CODE} eq '11')   # superseded 16th Nov 
	    # one of: 11,26,28,62
		elsif ($d->{CALL_SERVICE_CODE} =~ /^11$|^12$|^26$|^28$|^62$/)
		{
			$ST_VOICE = TRUE; push @serviceTypes, "ST_VOICE";
			$ST_UNIDENT = FALSE;
		}
		elsif (defined $d->{CALL_SERVICE_TYPE})
		{
			if
			(
				$d->{CALL_SERVICE_TYPE} eq '10' and 
				$d->{CALL_SERVICE_CODE} =~ /^4[0-5]|5[01]$/
			)
			{
				$ST_MMS = TRUE; push @serviceTypes, "ST_MMS";
				$ST_UNIDENT = FALSE;
			}
		}
	}

	if (defined $d->{CALL_BREAKDOWN_CODE})
	{
		if($d->{CALL_BREAKDOWN_CODE} =~ /3GPS|GPRS|ROAMB|ROAME|ROAMI|ROAMO|ROAMW|DRNFP|DRTFP/)
		{
			$ST_DATA = TRUE;
			$ST_DATA_GPRS = TRUE; push @serviceTypes, "ST_DATA_GPRS";
			$ST_DATA_GPRS_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_GPRS_POSTPAID";
			$ST_UNIDENT = FALSE;
		}
		elsif($d->{CALL_BREAKDOWN_CODE} =~ /WAPAD|NZ1P1|NZ1P2|NZ2P1|NZ3P1|NZ4P1|PZ1P0|PZ2P1|PZ3P1|PZ4P1|NZ1P0|NZ2P0|NZ3P0|NZ4P0|PZ2P0|PZ3P0|PZ4P0/)
		{
			$ST_DATA = TRUE;
			$ST_DATA_WAP_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_WAP_POSTPAID";
		    if($d->{CALL_BREAKDOWN_CODE} eq 'WAPAD')
			{
			    $ST_DATA_WAP = TRUE; push @serviceTypes, "ST_DATA_WAP";
			}
			$ST_UNIDENT = FALSE;
		}
		elsif($d->{CALL_BREAKDOWN_CODE} =~ /ERONE|ERDFT|ERUSE|ERSU2|ERSU1|ERONE|ERDFT|ERDEF/)
		{
			$ST_CONTENT = TRUE;
			$ST_CONTENT_POSTPAID = TRUE; push @serviceTypes, "ST_CONTENT_POSTPAID";
			$ST_UNIDENT = FALSE;
		}
	}
		
	# ---- USAGE


	# ---- TIMESLOT
	my $startDate = (defined $d->{DAILY_START_DATE}) ? $d->{DAILY_START_DATE} : "";
	my $startTime = "";
	my $timeSlot = "";
	$startDate =~ s/\s//g;
	if ($startDate =~ m:^(\d+)/(\d+)/(\d+)$:)
	{
		$startDate = sprintf "%4d%02d%02d", "20$3",$2,$1;
		$startTime = (defined $d->{DAILY_START_TIME}) ? $d->{DAILY_START_TIME} : "";
		$startTime =~ s/^(\d{2}):(\d{2}):(\d{2})/$1/;
		$timeSlot = $startDate . $startTime;
	}
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT


	# ---- RULES
	if ($ST_SMS)
	{
		$usageType = "SMS";

		if (defined $d->{CALL_IMSI} and $d->{CALL_IMSI} =~ /^27201/) # begins with 27201
		{
			$ST_SMS_HOME = TRUE; push @serviceTypes, "ST_SMS_HOME";

			if (defined $d->{CALL_DIALLED_DIGITS})
			{
				if ($d->{CALL_DIALLED_DIGITS} =~ /^VF/) # begins with VF
				{
					$ST_SMS_VODAFONE = TRUE; push @serviceTypes, "ST_SMS_VODAFONE"; # begins with VF
				}
				elsif ($d->{CALL_DIALLED_DIGITS} =~ /^BT/) # begins with BT
				{
					$ST_SMS_O2 = TRUE; push @serviceTypes, "ST_SMS_O2"; # begins with BT
				}
				elsif ($d->{CALL_DIALLED_DIGITS} =~ /^ME/)
				{
					$ST_SMS_METEOR = TRUE; push @serviceTypes, "ST_SMS_METEOR";
				}
				elsif ($d->{CALL_DIALLED_DIGITS} =~ /^HU/)
				{
					$ST_SMS_HUTCHINSON = TRUE; push @serviceTypes, "ST_SMS_HUTCHINSON";
				}
				elsif ($d->{CALL_DIALLED_DIGITS} =~ /^TE/)
				{
					$ST_SMS_TESCO = TRUE; push @serviceTypes, "ST_SMS_TESCO";
				}
				elsif ($d->{CALL_DIALLED_DIGITS} =~ /^AP/)
				{
					$ST_SMS_POSTFONE = TRUE; push @serviceTypes, "ST_SMS_POSTFONE";
				}
				elsif ($d->{CALL_DIALLED_DIGITS} =~ /^JM/)
				{
					$ST_SMS_JUSTMOBILE = TRUE; push @serviceTypes, "ST_SMS_JUSTMOBILE";
				}
				elsif ($d->{CALL_DIALLED_DIGITS} =~ /^0/)
				{
					$ST_SMS_OTHER_DEST = TRUE; push @serviceTypes, "ST_SMS_OTHER_DEST";
				}
				elsif ($d->{CALL_DIALLED_DIGITS} =~ /^5\d{4}/) # begins with 5 and has length of 5 digits
				{
					$ST_SMS_PREMIUM = TRUE; push @serviceTypes, "ST_SMS_PREMIUM"; # begins with 5 and has length of 5 digits
				}
			}

			if (defined $d->{CALL_RECORD_TYPE} and defined $d->{CALL_SERVICE_CODE})
			{
				if 
				(
					$d->{CALL_RECORD_TYPE} eq '20' and 
					$d->{CALL_SERVICE_CODE} =~ /^22/
				)
				{
					$ST_SMS_HOME_MO = TRUE; push @serviceTypes, "ST_SMS_HOME_MO";
				}
				elsif 
				(
					$d->{CALL_RECORD_TYPE} eq '30' and 
					$d->{CALL_SERVICE_CODE} =~ /^21/
				)
				{
					$ST_SMS_HOME_MT = TRUE; push @serviceTypes, "ST_SMS_HOME_MT";
				}
			}
		}

		if (defined $d->{CALL_BREAKDOWN_CODE} and $d->{CALL_BREAKDOWN_CODE} eq 'ROAMR')
                {
                        $ST_SMS_OTHER_OUTBOUND_ROAMERS_MO = TRUE; push @serviceTypes, "ST_SMS_OTHER_OUTBOUND_ROAMERS_MO";
                }

		if (    ( defined $d->{CALL_BREAKDOWN_CODE} and $d->{CALL_BREAKDOWN_CODE} eq 'SMSMT' )
		    and ( defined  $d->{CALL_TAP_IND} and  $d->{CALL_TAP_IND} eq '1' ) )
		{
			$ST_SMS_OTHER_OUTBOUND_ROAMERS_MT = TRUE; push @serviceTypes, "ST_SMS_OTHER_OUTBOUND_ROAMERS_MT";
		}

	}
	elsif ($ST_VOICE)
	{
		$usageType = "VOICE";

		if (defined  $d->{CALL_TAP_IND} and  $d->{CALL_TAP_IND} eq '1')
		{
			$ST_VOICE_OTHER_OUTBOUND_ROAMERS = TRUE; push @serviceTypes, "ST_VOICE_OTHER_OUTBOUND_ROAMERS";

			if (defined $d->{CALL_IMSI} and $d->{CALL_IMSI} =~ /^27201[^1]/) # must begin with ^27201 but not ^272011 MVNO ?
 	                {

				if ($d->{CALL_RECORD_TYPE} eq "20")
				{
					$ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MO = TRUE; push @serviceTypes, "ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MO";
				}
				elsif ($d->{CALL_RECORD_TYPE} eq "30")
				{
					$ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MT = TRUE; push @serviceTypes, "ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MT";
				}
			}
		}

		if (defined $d->{CALL_IMSI} and $d->{CALL_IMSI} !~ /^27201/)
		{
			$ST_VOICE_OTHER_INBOUND_ROAMERS = TRUE; push @serviceTypes, "ST_VOICE_OTHER_INBOUND_ROAMERS";
		}

		# ONXP 
		$self->IMSI($d->{CALL_IMSI}) if (defined $d->{CALL_IMSI});
		my $isOnxp = $self->isOnxpImsi();
	
		$ST_VOICE_ROAMERS = FALSE;

		if ($ST_VOICE_OTHER_OUTBOUND_ROAMERS) 
		{
			$ST_VOICE_ROAMERS = TRUE;
		}	

		if ($ST_VOICE_OTHER_INBOUND_ROAMERS)
		{
			$ST_VOICE_ROAMERS = TRUE;
		}

		if (not $ST_VOICE_ROAMERS)
                {
			$ST_VOICE_POSTPAID = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID";
                        push @serviceTypes, "ST_ONXP_VOICE_POSTPAID" if ($isOnxp);

			if (defined $d->{CALL_IMSI} and $d->{CALL_IMSI} =~ /^27201[^1]/) # must begin with ^27201 but not ^272011 MVNO ?
			{
				$ST_VOICE_POSTPAID_HOME = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME";
				push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME" if ($isOnxp);

				if (defined $d->{CALL_RECORD_TYPE})
				{
					if ($d->{CALL_RECORD_TYPE} eq '20')
					{
						$ST_VOICE_POSTPAID_HOME_MO = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME_MO";
						push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME_MO" if ($isOnxp);
					}
					elsif ($d->{CALL_RECORD_TYPE} eq '21')
					{
						$ST_VOICE_POSTPAID_HOME_CALL_FWD = TRUE; push @serviceTypes, "ST_VOICE_POSTPAID_HOME_CALL_FWD";
						push @serviceTypes, "ST_ONXP_VOICE_POSTPAID_HOME_CALL_FWD" if ($isOnxp);
					}
				}
			}
		}
	}
	elsif ($ST_MMS)
	{
		$usageType = "MMS";
		$callDirection = "MO";
		
		$ST_MMS_POSTPAID = TRUE; push @serviceTypes, "ST_MMS_POSTPAID";
		$ST_MMS_POSTPAID_HOME = TRUE; push @serviceTypes, "ST_MMS_POSTPAID_HOME";
		$ST_MMS_POSTPAID_HOME_MO = TRUE; push @serviceTypes, "ST_MMS_POSTPAID_HOME_MO";
	}
	elsif ($ST_DATA)
	{
		$usageType = "DATA";
	}
	elsif ($ST_CONTENT)
	{
		$usageType = "CONTENT";
	}
	else
	{
		$ST_UNIDENT = TRUE; push @serviceTypes, "ST_UNIDENT";

		#$self->{logger}(" **** Catch-all reached, this should not happen. Record " . $self->{input_record_count} . " in file " . $self->{input_file_obj}{edr_file_name} );              
        $self->{logger}(" **** Catch-all reached, this should not happen. " . 
            "(SERVICE_CODE = "   . $d->{CALL_SERVICE_CODE} . 
			" SERVICE_TYPE = "   . $d->{CALL_SERVICE_TYPE} . 
			" BREAKDOWN_CODE = " . $d->{CALL_BREAKDOWN_CODE} . ")" .
			" Record " . $self->{input_record_count} . 
			" in file " . $self->{input_file_obj}{edr_file_name} );              
        $self->{debugger}( " **** CALL_SERVICE_CODE = " . ( defined $d->{CALL_SERVICE_CODE} ) ? $d->{CALL_SERVICE_CODE} : "null" ); 
        $self->{debugger}( " **** CALL_SERVICE_TYPE = " . ( defined $d->{CALL_SERVICE_TYPE} ) ? $d->{CALL_SERVICE_TYPE} : "null" );
        $self->{debugger}( " **** CALL_BREAKDOWN_CODE = " . ( defined $d->{CALL_BREAKDOWN_CODE} ) ? $d->{CALL_BREAKDOWN_CODE} : "null" );
	}
	# ---- RULES
	$self->D_USAGE_TYPE($usageType);        #AGGREGATOR KEY

	my $duration = (defined $d->{CALL_DURATION}) ? $d->{CALL_DURATION} : 0;
	my $volume   = (defined $d->{CALL_DATA_VOL}) ? $d->{CALL_DATA_VOL} : 0;
	my $revenue  = 0;
	if (defined $d->{CALL_RETAIL_PRICE} and defined $d->{CALL_DISCOUNT})
	{
		$revenue = $d->{CALL_RETAIL_PRICE} - $d->{CALL_DISCOUNT};
	}

	#--- EVERYTHING BELOW IS REQUIRED
	# ---- FILL AGGREGATION DATA STRUCTURE
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => $duration,
			sum_bytes    => $volume,
			sum_value    => $revenue
		}
	); # call the method in the parent class
	# ---- FILL AGGREGATION DATA STRUCTURE
}
#------------------------------------------------------------------------------



1;
