package Ascertain::UM::VFI::Aggregator;

use File::Copy;
use FileHandle;
use Time::Local 'timelocal_nocheck';
use Data::Dumper;
use Time::HiRes qw( gettimeofday usleep ); 

#use vars qw($AUTOLOAD); # 

use constant SECONDS_PER_DAY => 24 * 60 * 60;
use constant CENTS_TO_EURO_FACTOR => 100;
use constant TRUE => 1;
use constant FALSE => undef;

#------------------------------------------------------------------------------
# This is for contructing this Aggregator
#  - The data_source arg determines which subclass to instantiate
#------------------------------------------------------------------------------
sub new
{
	my $proto = shift;
	my $class = ref $proto || $proto;
	my $self = {};

	my $args = shift;
	my $dataSource = $args->{data_source};
	$self->{data_source} = $dataSource;
	$self->{neid} = $args->{neid};
	$self->{logger} = $args->{logger};
	$self->{debugger} = $args->{debugger};
	$self->{timeslot_validity_window} = $args->{timeslot_validity_window}; # don't write records older than this many days
	$self->{parameters} = $args->{parameters};

	$self->{aggregation} = {}; # this will hold the dimensions, and counters
	$self->{input_file_lookup} = {}; # this will provide a file lookup 
	$self->{currency_factor} = defined ($args->{currency_factor}) ? $args->{currency_factor} : 1;  # from Format object if in euros then 1, if in cents then 100
	$self->{data_factor} = defined ($args->{data_factor}) ? $args->{data_factor} : 1;  # from Format object if in bytes then 1, if in MB then 1048576
	$self->{continue_processing} = TRUE;
	$self->{logger}("Currency factor in use is : " .  $args->{currency_factor});
	$self->{logger}("Data     factor in use is : " .  $args->{data_factor});

	# create this as the subclass which contains just the 'aggregate' method
	my $subClass = "Ascertain::UM::VFI::Aggregator::$dataSource";
	bless $self, $subClass;
	#$self->setValidAttributes();
	$self->{debugger}("Subclassing this class as : $subClass");
	$self->{logger}("Creating Aggregator -> $subClass");
	$self->{runtime} = $self->getTimestamp(time);
	return $self;
}
#------------------------------------------------------------------------------

# make sure users of this super class get it right
# subClass must override this
sub aggregate 
{ 
	my $self = shift; 
	my $args = shift;
	$self->{record} = $args->{record};
	$self->{reader_object} = $args->{reader_object};
	$self->{input_file_obj}->incrementAggregatedLineCount(); # do this for every subclass
	$self->{total_aggregated_line_count}++; # keep track of total
	$self->_aggregate($args); # now call the sub class method
}

sub continueProcessing
{
	my $self = shift;
	return $self->{continue_processing}; 
}

sub setInputFileObject
{
	my $self = shift;
	$self->{input_file_obj} = shift;
	my $fileNumber = $self->{input_file_obj}->getFileNumber();
	$self->{input_file_lookup}->{$fileNumber} = $self->{input_file_obj};
}
sub getInputFileObject
{
	my $self = shift;
	return $self->{input_file_obj};
}

sub getAggregationResults
{
	my $self = shift;
	return $self->{aggregation};
}

sub getNonAggregatedRecordsWritten
{
	my $self = shift;
        return $self->{non_aggregated_records_written};
}

sub setNonAggregatedRecordsWritten
{
        my $self = shift;
        $self->{non_aggregated_records_written} = shift;
}

sub setNeId
{
	my $self = shift;
	$self->{neid} = shift;
}
sub getNeId
{
	my $self = shift;
	return $self->{neid};
}

sub setNonAggregationMode
{
	my $self = shift;
	$self->{non_aggregation_mode} = TRUE;
}

sub isNonAggregationMode
{
	my $self = shift;
	return $self->{non_aggregation_mode};
}

sub setTaskObject
{
	my $self = shift;
	$self->{task_object} = shift;
	$self->{non_aggregation_mode} = TRUE; # why not ?
}

sub D_USAGE_TYPE
{
	my $self = shift;
	my $arg = shift;
	if (defined $arg)
	{
		$self->{usage_type} = $arg;
	}
	else
	{
		return $self->{usage_type};
	}
}
sub D_SERVICE_TYPE
{
	my $self = shift;
	my $arg = shift;
	if (defined $arg)
	{
		$self->{service_type} = $arg;
	}
	else
	{
		return $self->{service_type};
	}
}
sub D_TIMESLOT
{
	my $self = shift;
	my $arg = shift;
	if (defined $arg)
	{
		$self->{timeslot} = $arg;
	}
	else
	{
		return $self->{timeslot};
	}
}
sub IMSI
{
	my $self = shift;
	my $arg = shift;
	if (defined $arg)
	{
		$self->{imsi} = $arg;
	}
	else
	{
		return $self->{imsi};
	}
}
sub isOnxpImsi
{
	my $self = shift;
	my $imsi = shift;
	if (defined $imsi)
	{
		$self->IMSI($imsi); # set this if called with an arg, else could be set earlier
	}
	return 
		((defined $self->{imsi}) and (exists $self->{onxp_list}->{$self->{imsi}}))
		? TRUE
		: FALSE;
}
sub setOnxpList
{
	my $self = shift;
	$self->{onxp_list} = shift;
}

sub isItcRouteValue
{
    my $self = shift;

    my $inRoute = shift;
    my $outRoute = shift;

    my $star = "*";

    if ($inRoute eq "" or (not defined $inRoute) ) {
        $inRoute = "NULL";
    }

    if ($outRoute eq "" or (not defined $outRoute) ) {
        $outRoute = "NULL";
    }

    if ( defined $inRoute and defined $outRoute ) {
        if ( $self->{itc_routes}->{$star}->{$outRoute}->{flag} eq "Y") {
            return "OMATCH";
        }
        elsif ( $self->{itc_routes}->{$inRoute}->{$star}->{flag} eq "Y") {
            return "IMATCH";
        }
        elsif (  $self->{itc_routes}->{$inRoute}->{$outRoute}->{flag} eq "Y") {
            return "FMATCH";
        }
        else {
            return "NOMATCH";
        }
    }
    else {
        return "NOMATCH";
    }
}

sub addItcRouteValue
{
    my $self = shift;

    my $inRoute = shift;
    my $outRoute = shift;

    if ($inRoute eq "" or (not defined $inRoute) ) {
        $inRoute = "NULL";
    }

    if ($outRoute eq "" or (not defined $outRoute) ) {
        $outRoute = "NULL";
    }


    if ( defined $inRoute and defined $outRoute ) {
        if ( not exists $self->{itc_routes}->{$inRoute}->{$outRoute}->{flag} ) {
			$self->{itc_routes}->{$inRoute}->{$outRoute}->{flag} = "Y";
			$self->{itc_routes}->{$inRoute}->{$outRoute}->{desc} = $self->{runtime} . ": Added by system";
        }
        elsif ( $self->{itc_routes}->{$inRoute}->{$outRoute}->{flag} eq "N" ) {
            # Update to Y
	    $self->{itc_routes}->{$inRoute}->{$outRoute}->{flag} = "Y";
            $self->{itc_routes}->{$inRoute}->{$outRoute}->{desc} = $self->{runtime} . ": Updated to Y by system";
        }
    }
}

sub setPartnersList
{
    my $self = shift;
    $self->{partners} = shift;
}

sub getPartnersList
{
    my $self = shift;
    return $self->{itc_routes};
}

sub setIntRouteList 
{
	my $self = shift;
    $self->{itc_routes} = shift;
	
}

sub getIntRouteList
{
	my $self = shift;
	return $self->{itc_routes};
}

sub isPartner 
{
	my $self = shift;
	my $subsIMSI = shift;

	if (defined $subsIMSI ) {
		for my $partner (@{$self->{partners}}) 
		{
			if ($subsIMSI >= $partner->{startIMSI} and $subsIMSI <= $partner->{endIMSI} ) 
			{
				return $partner->{sourceDesc};
			}
		}
		return 0;
	}
    else {
            return 0;
    }
}

sub isItcExcServiceCentreValue
{
        my $self = shift;

                my $calledSubsImsi = shift;
        my $serviceCentre = shift;

                my $imsi_match = FALSE;
                my $serviceCentre_match = FALSE;

        if ( defined $serviceCentre and defined $calledSubsImsi ) {

                        for my $sc (@{$self->{itc_serviceCentres}}) {
                                my ($imsiExpr, $serviceCentreExpr) = split (/;/,$sc);

                                # imsi negative match test
                                if ($imsiExpr =~ /^!/) {
                                        $imsiExpr =~ s/!//g;
                                        if ($calledSubsImsi !~ /^$imsiExpr/) {
                                                $imsi_match = TRUE;
                                        }
                                }
                                # imsi match test
                                else {
                                        if ($calledSubsImsi =~ /^$imsiExpr/) {
                                $imsi_match = TRUE;
                        }
                                }

                                # Service Centre Negative match test
                                if ($serviceCentreExpr =~ /^!/) {
                                        $serviceCentreExpr =~ s/!//g;
                                        if ($serviceCentre !~ /^$serviceCentreExpr/) {
                                                $serviceCentre_match = TRUE;
                                        }
                                }
                                # Service Centre match test
                                else {
                                        if ($serviceCentre =~ /^$serviceCentreExpr/) {
                                                $serviceCentre_match = TRUE;
                        }
                                }


                                if ($imsi_match and $serviceCentre_match) {
                                        return TRUE;
                                }

                                $imsi_match = FALSE;
                                $serviceCentre_match = FALSE;
                        }
                        return FALSE;
        }
        else {
            return FALSE;
        }
}

sub setIntServiceCentreList
{
        my $self = shift;
        $self->{itc_serviceCentres} = shift;
}


sub isICCSFreeNumber
{
        my $self = shift;

        my $dialledDigit = shift;

	$dialledDigit =~ s/\s+//g;

        if ( defined $dialledDigit ) {
	
                for my $dd (@{$self->{itc_freeNumbers}}) {
                        if ($dialledDigit =~ /^$dd$/) {
                                return TRUE;
                        }
                }
                return FALSE;
        }
        else {
                return FALSE;
        }
}

sub setICCSFreeNumberList
{
        my $self = shift;
        $self->{itc_freeNumbers} = shift;
}



# choose either addAggregatedResults or in non-aggregation mode write the record
sub process
{
	my $self = shift;
	# args is hash
	# {event_count => #, sum_duration => #,sum_bytes => #, sum_value => #}
	my $args = shift;
	if (defined $self->{non_aggregation_mode})
	{
		my $oTask = $self->{task_object};
		my $match = 0;
		my $ts = $self->D_TIMESLOT();
		my $start = $oTask->getStartTimeslot();
		my $end = $oTask->getEndTimeslot();
		foreach my $st ($oTask->getServiceTypes())
		{
			foreach my $serviceType (@{$self->{service_types}})
			{
				$match++ if 
				(
						($serviceType eq $st) and
						($ts >= $start) and 
						($ts <= $end)
				);
			}
		}
		if ($match)
		{
			my $fh = $oTask->getOutputFH();
			# print column names
			if ($self->{non_aggregated_records_written} == 0)
			{
				my $columnNames = $self->{reader_object}->getFieldNamesAsCsv();	
				print $fh "$columnNames\n" or die("Can't print\n");
			}
			my $line = $self->{reader_object}->getRecordAsCsv($self);
			print $fh "$line\n" or die("Can't print\n");
			$self->{non_aggregated_records_written}++; # stop when max_records is reached;
			if ($self->{non_aggregated_records_written} >= $oTask->getMaxRecords())
			{
				$self->{continue_processing} = FALSE;
			}
		}
	}
	else
	{
		# normal aggregation mode
		foreach my $serviceType (sort @{$self->{service_types}})
		{
			$self->D_SERVICE_TYPE($serviceType);
			$self->addAggregatedResults($args);
		}
	}
}

sub addAggregatedResults
{
	my $self = shift;
	# args is hash
	# {event_count => #, sum_duration => #,sum_bytes => #, sum_value => #}
	my $args = shift;


	my $fileNumber = $self->{input_file_obj}->getFileNumber();
	my $neId = $self->{input_file_obj}->getNeId();
	my $edrFileName = $self->{input_file_obj}->getEdrFileName();

	# keep count of records that participate in aggregation which will be the key count here
	# input_record_count will be 1 at record 1, if addAggregatedResults is called 10 times (1 for each service ST_)
	# then there will be 1 key
	# if record 2 is iNIncomingCall with no timeStamp this sub will not get called, so key count still 1
	# 2 records readr: 1 record participated in aggregation, 1 ignored
	#$self->D_NEID($self->{input_file_obj}->getNeId());
	#$self->D_EDR_FILENAME($self->{input_file_obj}->getEdrFileName());

	# $counter is one of: {event_count, sum_duration,sum_bytes, sum_value}
	foreach my $counter (keys %{$args})
	{	
		my $value = $args->{$counter} or 0;
		if ($value !~ /[0-9.]+/)
		{
			$value = 0; # non digit passed in
		}
		if ($counter eq "sum_value")
		{
			$value *= $self->{currency_factor}; # convert from euro to cents
		}
		if ($counter eq "sum_bytes")
		{
			$value /= $self->{data_factor}; # convert from bytes to MB
		}
		
		my $sourceDesc = "";

                if (exists $self->{definedSource}->{$self->D_SERVICE_TYPE}) {
                        $sourceDesc = $self->{definedSource}->{$self->D_SERVICE_TYPE};
                }
                else {
                        $sourceDesc = $neId;
                }

		$self->{aggregation}->{
			$fileNumber}->{
				$self->D_USAGE_TYPE}->{
					$sourceDesc}->{
						$self->D_TIMESLOT}->{
							$self->D_SERVICE_TYPE}->{$counter} += $value;
	}
}


sub specifySourceForAggRecords {

    my $self = shift;
    my $serviceType = shift;
    my $sourceDesc = shift;

    $self->{definedSource}->{$serviceType} = $sourceDesc;

}

sub specifySourceInit {

    undef $self->{definedSource};
}



sub writeAggregatedFile
{
	my $self = shift;
	my $args = shift;
	
	my $outputDir = $args->{output_dir};
	my $currentDir = $args->{current_dir};
	my $errorDir = $args->{error_dir};

	my $ds = $self->{aggregation};
	my $dsr = $self->{aggregation_removed};
	my $dsm = { %$ds, %$dsr };

	my $dataSource = $self->{data_source};

	TIMESLOT:
	# Get epoch seconds and microseconds
	my ($seconds , $microseconds) = gettimeofday; 
	# Make a nice date format
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($seconds); 
	# Join the date and microseconds
	my $runtimemicro = sprintf "%4d%02d%02d%02d%02d%02d%06d", $year+1900,$mon+1,$mday,$hour,$min,$sec,$microseconds; 
	my $dateByHour = sprintf   "%4d%02d%02d%02d", $year+1900,$mon+1,$mday,$hour;

	my $outputFile = "$outputDir/$runtimemicro.$dataSource.out";
	my $errorFile  = "$errorDir/$runtimemicro.$dataSource.err";
	my $openFile   = "$outputFile.open";
	#open OUT, ">>$openFile" or die("Aggregator.pm->writeAggregatedFile : Cannot open file [$openFile]\n");
	$self->{debugger}("Creating output file: [$openFile]");
	my $out_fh = new FileHandle(">$openFile");
	my $out_rc = 0; # outfile record count
	my $err_fh = new FileHandle(">$errorFile");
	my $err_rc = 0; # errfile record count
	print $out_fh "currentDir,edrFileName,neId,umIdentifier,usageType,timeSlot,serviceType,eventCount,sumDuration,sumBytes,sumValue\n" unless ($fileExists);
	my $work_fh = $out_fh;
	my $work_rc;


  foreach my $fileNumber (sort keys %{$dsm})
  {
		my $edrFileName = $self->{input_file_lookup}->{$fileNumber}->getEdrFileName();
		my $edrFileDate = $self->{input_file_lookup}->{$fileNumber}->getTimestamp();
		my $edrFileSize = $self->{input_file_lookup}->{$fileNumber}->getEdrFileSize();
		
		my $edrNeId = $self->{input_file_lookup}->{$fileNumber}->getNeId();
		my $rejectedCount = 0;

		foreach my $usageType (sort keys %{$dsm->{$fileNumber}})
		{
			foreach my $neId (sort keys %{$dsm->{$fileNumber}->{$usageType}})
			{
				foreach my $timeSlot (sort keys %{$dsm->{$fileNumber}->{$usageType}->{$neId}})
				{
					$self->{debugger}("Writing data for : file [$fileNumber : $edrFileName] usage [$usageType] neid [$neId] slot [$timeSlot]");
					unless ($self->isTimeSlotValid($timeSlot))
					{
						$self->{logger}("Found old data for time slot : $timeSlot, moving to: error_dir");
						$rejectedCount++;
						$work_fh = $err_fh;
						$work_rc = \$err_rc;
					}
					else
					{
						$work_fh = $out_fh;
						$work_rc = \$out_rc;
					}
					foreach my $serviceType (sort keys %{$ds->{$fileNumber}->{$usageType}->{$neId}->{$timeSlot}})
					{
						my $eventCount = $ds->{$fileNumber}->{$usageType}->{$neId}->{$timeSlot}->{$serviceType}->{event_count};
						my $sumDuration = $ds->{$fileNumber}->{$usageType}->{$neId}->{$timeSlot}->{$serviceType}->{sum_duration};
						my $sumBytes = $ds->{$fileNumber}->{$usageType}->{$neId}->{$timeSlot}->{$serviceType}->{sum_bytes};
						# sum bytes can be in MB, from dividing by (1024 x 1024) which can give tiny numbers, so restrict decimal places - 4 seems reasonable
						$sumBytes = sprintf "%.4f", $sumBytes;
						my $sumValue = $ds->{$fileNumber}->{$usageType}->{$neId}->{$timeSlot}->{$serviceType}->{sum_value};
						$sumValue = ($sumValue > 0) ? sprintf "%.2f", ($sumValue/CENTS_TO_EURO_FACTOR) : "0.00"; # convert from cents to euro
						my $umIdentifier = "$dataSource.$usageType.$timeSlot";
						print $work_fh "$currentDir,$edrFileName,$neId,$umIdentifier,$usageType,$timeSlot,$serviceType,$eventCount,$sumDuration,$sumBytes,$sumValue\n";
						$$work_rc++;
					}
				}
			}
		}

		# Output File Metric Service Type
		if ($rejectedCount > 0) {
			print $out_fh "$currentDir,$edrFileName,$edrNeId,$dataSource.FILE.${edrFileDate}00,FILE,${edrFileDate}00,ST_AGG_REJECTED,$rejectedCount,0,$edrFileSize,0.0\n";
		}
		elsif (exists $dsr->{$fileNumber}) {
    	        	print $work_fh "$currentDir,$edrFileName,$edrNeId,$dataSource.FILE.${edrFileDate}00,FILE,${edrFileDate}00,ST_AGG_FAILED,1,0,$edrFileSize,0.0\n";
        	}
       		else {
            		print $work_fh "$currentDir,$edrFileName,$edrNeId,$dataSource.FILE.${edrFileDate}00,FILE,${edrFileDate}00,ST_AGG_SUCCESS,1,0,$edrFileSize,0.0\n";
        	}
		$out_rc++;
	}
	

	if( exists( $self->{timeslotError} ) && scalar( keys( %{ $self->{timeslotError} } ) ) )
	{
	    $self->{logger}( "Timeslot problems were found for following recordtypes:" );
	    
	    foreach my $type ( keys %{ $self->{timeslotError} } )
	    {
	       $self->{logger}( "\t" . $type . " - " . $self->{timeslotError}{$type} . " instances" );
	    }
    }

	opendir my $dir, "$errorDir" or die "Cannot open $errorDir directory: $!";
	my @errFiles = readdir $dir;
	closedir $dir;
	
	for my $erroredFile (@errFiles) {
		if ($erroredFile =~ /err_decoded$/) {
			print $out_fh "$currentDir,$erroredFile,UNKNOWN,$dataSource.FILE.${dateByHour},FILE,${dateByHour},ST_AGG_FAILED,1,0,0,0.0\n";
			$out_rc++;
			move($errorDir . "/" . $erroredFile, $errorDir . "/" . $erroredFile . "_reported");
		}
	}

	close $out_fh;
	close $err_fh;
	if ($out_rc > 0)
	{
		$self->{debugger}("Renaming file: [$openFile] to [$outputFile]");
		$self->{logger}("Output file is: $outputFile");
		move($openFile, $outputFile);
	}
	else
	{
		$self->{debugger}("Cleaning up empty output file.");
		unlink($openFile);
	}
	unless($err_rc > 0)
	{
		$self->{debugger}("Cleaning up empty error file.");
		unlink($errorFile);
	}
}

sub removeFailedFileResults
{
	my $self = shift;
	my $fileNumber = shift;
	my $fileName = $self->{input_file_lookup}->{$fileNumber}->getEdrFileName();

	$self->{logger}("Removing results for failed file number [$fileNumber][$fileName].");
	$self->{aggregation_removed}->{$fileNumber} = $self->{aggregation}->{$fileNumber};
	delete $self->{aggregation}->{$fileNumber};
}

# return count of records going into the aggregate sub
sub getInputRecordCount
{
	my $self = shift;
	return $self->{input_record_count};
}

# return count of records that were parsed and participated in aggregation
# invalids and unparseable records with no timestamp will not be here
# this should equal the sum of all eventCount for this file 
# and can be calculated by summing the eventCount values for each line in each output file
sub getAggregatedRecordCount
{
	my $self = shift;
	return $self->{total_aggregated_line_count};
	#return scalar(keys %{$self->{aggregator_bucket}});
}

sub getUnAggregatedRecordCount
{
	my $self = shift;	
	return exists( $self->{unaggregateable} ) ? $self->{unaggregateable} : 0;	
}

sub getTimestamp
{
	my $self = shift;
  my $t = shift;
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime($t);
  return sprintf "%4d%02d%02d%02d%02d%02d", $year+1900,$mon+1,$mday,$hour,$min,$sec;
}

#- return TRUE if time slot is withing the configured number of days
sub isTimeSlotValid
{
	my $self = shift;
	my $ts = shift;

	$ts =~ s/^(\d{4})(\d{2})(\d{2})(\d{2})/$1,$2,$3,$4/;
	my ($year, $month, $day, $hour) = split /,/, $ts;
	my $ts_time = timelocal_nocheck(0,0,$hour,$day,--$month,$year);

	my $now_time = time;

	return (($now_time - $ts_time) > ($self->{timeslot_validity_window} * SECONDS_PER_DAY)) ? FALSE : TRUE;
}

#---------------------- AUTOLOADING BELOW HERE ------------------------
# This way I don't need a setter and getter for everything
# call $self->D_TIMESLOT($timeSlot) to set the value
# call $self->D_TIMESLOT() to get the value
# note that the D_TIMESLOT sub does not exist, it is created for you when you use it
sub AUTOLOAD
{
  my $self = shift;
  my $attr = $AUTOLOAD;
  $attr =~ s/.*:://;
  return unless $attr =~ /[^A-Z]/;
	
	
	my $p = "";
	$p = shift if (@_);

  # skip DESTROY and all-cap methods
  die ("Aggregator sub class called an invalid attribute method: -> $attr()") 
		unless $self->{valid_attributes}->{$attr};
  $self->{uc $attr} = $p if ($p);
  return $self->{uc $attr};
}

#-- setValidAttributes 
#--   define the valid getters and setters for AUTOLOADed method calls
#--   values returned by getAttributeNames() will allow methods of the same name to be
#--     called or set storing data for the sub classed modules
sub setValidAttributes
{
	my $self = shift;
	map {$self->{valid_attributes}->{$_}++} getAttributeNames();
}
sub getAttributeNames
{
	return qw (D_NEID D_EDR_FILENAME D_TIMESLOT D_USAGE_TYPE D_SERVICE_TYPE);
=top
	return qw
	(
		D_NEID
		D_EDR_FILENAME
		D_TIMESLOT
		D_USAGE_TYPE
		D_SERVICE_TYPE
		D_SUBS_TYPE
		D_CALL_DIRECTION
		D_ROAMING
		ST_ALL
		ST_VOICE
		ST_VOICE_POSTPAID
		ST_VOICE_POSTPAID_HOME
		ST_VOICE_POSTPAID_HOME_MO
		ST_VOICE_POSTPAID_HOME_CALL_FWD
		ST_VOICE_PREPAID
		ST_VOICE_PREPAID_HOME
		ST_VOICE_PREPAID_HOME_MO
		ST_VOICE_PREPAID_HOME_CALL_FWD
		ST_VOICE_OTHER_OUTBOUND_ROAMERS
		ST_VOICE_OTHER_INBOUND_ROAMERS
		ST_VOICE_INTERCONNECT
		ST_SMS
		ST_SMS_HOME
		ST_SMS_HOME_MO
		ST_SMS_HOME_MT
		ST_SMS_VODAFONE
		ST_SMS_O2
		ST_SMS_METEOR
		ST_SMS_HUTCHINSON
		ST_SMS_TESCO
		ST_SMS_POSTFONE
		ST_SMS_JUSTMOBILE
		ST_SMS_OTHER_DEST
		ST_SMS_PREMIUM
		ST_SMS_PREPAID
		ST_SMS_OTHER_INBOUND_ROAMERS
		ST_SMS_OTHER_OUTBOUND_ROAMERS
		ST_SMS_ROAMING_MO_PREPAID
		ST_SMS_PREMIUM_MO_PREPAID
		ST_SMS_PREMIUM_MT_PREPAID
		ST_MMS
		ST_MMS_POSTPAID
		ST_MMS_POSTPAID_HOME
		ST_MMS_POSTPAID_HOME_MO
		ST_MMS_PREPAID
		ST_MMS_PREPAID_HOME
		ST_MMS_PREPAID_HOME_MO
		ST_MMS_OTHER
		ST_DATA_GPRS
		ST_DATA_WAP
		ST_DATA_GPRS_PREPAID
		ST_DATA_GPRS_POSTPAID
		ST_DATA_WAP_PREPAID
		ST_DATA_WAP_POSTPAID
		ST_DATA_GPRS_PREPAID_STRIP
		ST_DATA_GPRS_POSTPAID_STRIP
		ST_DATA_WAP_PREPAID_STRIP
		ST_DATA_WAP_POSTPAID_STRIP
		ST_CONTENT_POSTPAID
		ST_CONTENT_PREPAID
		ST_UNIDENT
	);
=cut
}
sub resetAttributes
{
	my $self = shift;
	map {$self->{$_} = undef} getAttributeNames();

	# this method is called once for each input record
	# by the subclass, so we can keep track of input_record_count
	$self->{input_record_count}++;
}

# the encoded representation below
#72 02 71 10 70 08 39 F4
# should read : 272017010780934
# note the 'F' as padding
sub decodeIMSI
{
	my $self = shift;
	my $pairString = shift;
	return $self->decodeDigitPairs($pairString);
}

sub decodeDigitPairs
{
	my $self = shift;
	my $pairString = shift;
	return "" unless (defined $pairString);
	my $imsi = join "", map {scalar reverse($_)} split /\s+/, $pairString;
	$imsi =~ s/[^\d]//g; # strip padding 'F'
	return $imsi;
}

# this will take a list of pairs in hex and return decimal pairs 
# 10 11 10 => 16 17 16 
# dates and times are stored like this
sub decodeHexPairs
{
	my $self = shift;
	my $pairString = shift;
	return join " ", map {sprintf("%02d", hex $_)} split /\s+/, $pairString;
}

# decode string like : 0D 06 0E
# into 20130614
sub decode3TupleDate
{
	my $self = shift;
	my $pairString = shift;
	my $dateString = $self->decodeHexPairs($pairString);	
	$dateString =~ s/\s+//g;
	return "20" . $dateString;
}

# decode string like : 03 2D 20
# into 03:45:20
sub decode3TupleTime
{
	my $self = shift;
	my $pairString = shift;
	my $timeString = $self->decodeHexPairs($pairString);	
	$timeString =~ s/\s+/:/g;
	return $timeString;
}

# the encoded representation below
#00 02 3B
# should read : 179
# assume 3 pairs in hex h, m, s
sub decodeDuration
{
	my $self = shift;
	my $pairString = shift;
	return 0 unless (defined $pairString);
	return 0 unless ($pairString =~ /[0-9A-F ]+/);
	my ($h, $m, $s) = split / /, $pairString;
	my $duration = (hex($s) + (60 * (hex($m))) + (60 * 60 * (hex($h))));
	return $duration;
}


# NEW decode revenue
sub decodeRevenue
{
        my $self = shift;
        my $pairString = shift;
        my @pairs = split /\s+/, $pairString;
        my $pair1 = shift @pairs;
        my $pair2 = shift @pairs;

        my $revenue = join "", map {scalar reverse($_)} @pairs;
        if ($revenue > 0)
        {
                if ($pair1 eq "04") {
                        $revenue = sprintf "%.2f", ($revenue);
                }
                else {
                        $revenue = sprintf "%.2f", ($revenue / 10);
                }
        }
        return $revenue;
}

sub decodeTimeslot
{
        my $self = shift;
        my $datetime = shift;

        my $d = "20" . $datetime;
        $d =~ s/\s//g;

        return $d if ($d =~ s/^(\d{14}).*/$1/); # parse success
        return FALSE; # parse failed
}

1;

