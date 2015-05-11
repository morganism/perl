#!/usr/bin/perl
###########################################################
# Script: run_missing_node_matches.pl
# Author: Cartesian Limited
#
# $Revision: 1.3 $
# 
# Procedure to check for Node Matches which have not been run, or have been run
# when data was not yet loaded in UM. If missing, then run the missing  node match
# January 2013
#
###########################################################

use English -qw (-no_match_vars);
use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

# No access to error Ascertain::Utils::exitCodes from library or from db when
# this is required so hard code this

use constant FAILED => 2;

###########################################################
# Load required Ascertain modules and handle any missing
# env variables or modules gracefully.
###########################################################
if (not defined $ENV{ASCERTAIN_BUILD})
{
  print STDERR "Environment variable ASCERTAIN_BUILD has not been set.\n" .
               "Script $PROGRAM_NAME exiting ...\n";
  exit(FAILED);
}

use lib "$ENV{ASCERTAIN_BUILD}/lib";
eval
{
  require Ascertain::Database::SQL;
  require Ascertain::Job;
  require Ascertain::Utils;
};
if ($EVAL_ERROR)
{
  print STDERR "Failed to load Ascertain perl modules [$EVAL_ERROR].\n" .
               "Script $PROGRAM_NAME exiting ...\n";
  exit(FAILED);
}

###########################################################
# Set globals and constants: debugging is off by default and
# is overriden by the -debug TYPE arguments are provided
###########################################################
use constant VERSION => '$Revision: 1.3 $';
use constant USAGE   => "Usage: $PROGRAM_NAME <jobId> <logFile> " .
                        "[-debug <all|base|sql> -version]";


###########################################################
# Read in arguments - job ID and logFile must always be
# passed as first arguments
###########################################################
my $jobId    = shift;
my $logFile  = shift;

if ( (not defined $jobId) or (not defined $logFile) )
{
  print USAGE . "\n";
  exit($Ascertain::Utils::exitCodes{USAGE});
}

###########################################################
# Process command line options.
###########################################################
my @extraOpts = ("lookbackdays=s");
my %argsHash = Ascertain::Utils::readArguments(USAGE, VERSION, \@ARGV, \@extraOpts);
my @debugList = (exists $argsHash{debug}) ? @{$argsHash{debug}} : ();

if (not exists $argsHash{lookbackdays})
{
  print USAGE . "\n";
  exit($Ascertain::Utils::exitCodes{USAGE});
}

my $lookbackdays = $argsHash{lookbackdays};

if (! looks_like_number($lookbackdays)) {
    $lookbackdays = 14;
}

###########################################################
# Create a Job object for given job id
###########################################################
my $dbUsername = Ascertain::Utils::getParameter(
                    "Ascertain.UM.VFI.DB_JOBS_USERNAME");
my $dbPassword = Ascertain::Utils::getParameter(
                    "Ascertain.UM.VFI.DB_JOBS_PASSWORD");

my $job = new Ascertain::Job($jobId,
                             $logFile,
                             $dbUsername,
                             $dbPassword,
                             $PROGRAM_NAME);

if (!$job)
{
  # Use print here as we can't be sure we have a log handle
  print STDERR "Failed to create a job object for job id $jobId.\n" .
               "Script $PROGRAM_NAME exiting ...\n";
  exit($Ascertain::Utils::exitCodes{IO});
}

$job->setDebugLevel(@debugList);

$job->write("Starting run missing node matches job (lookback = $lookbackdays)");

$dbUsername = Ascertain::Utils::getParameter(
                   "Ascertain.UM.VFI.DB_CUSTOMER_USERNAME");
$dbPassword = Ascertain::Utils::getParameter(
                   "Ascertain.UM.VFI.DB_CUSTOMER_PASSWORD");

my $dbh = DBI->connect("dbi:Oracle:$ENV{ORACLE_SID}",
                          $dbUsername, $dbPassword,
                          { PrintError => 0, RaiseError => 0});

if (!$dbh)
{
  $job->write("Failed to connect to database as user $dbUsername\n");
  exit($Ascertain::Utils::exitCodes{DB});
}

my $SQL = "select command
           from   ( 
		select x.d_day_id, x.node_id, x.description,x.name,filecount \"records matched\",
		       decode(y.d_day_id,null,'Y','N') missing,
		       decode(y.d_day_id,null,
		                   'jssubmitJob \"Node Matching on Specific Date\" \"-node ' || x.node_id  ||
		                   ' -matchdate ' || to_char(x.d_day_id,'YYYYMMDD') || 
		                   ' -match ' ||file_match_definition_id || 
		                   ' -rerun NO\" ',
		                   null ) command
		from   ( 
		         select d.d_day_id, n.node_id, n.description, c.latency, n.name, a.file_match_definition_id
		         from   um.d_day d,
 		               (select distinct nmj.node_id, nmj.file_match_definition_id
		                 from   um.node_match_jn nmj) a,
		                 customer.data_feed_frequency_ref c,
		                 dgf.node_ref n
		         where  d.d_day_id between sysdate - $lookbackdays and sysdate - 2 - nvl(c.latency,0)          
		         and    n.description = c.node
		         and    a.node_id = n.node_id
		         and    exists (select 1
		                        from   um.log_record lr
		                        where  lr.node_id = n.node_id
		                        and    lr.d_period_id between sysdate - $lookbackdays and sysdate - 1      
		                        and    trunc(lr.d_period_id) = d.d_day_id
		                        )
		       ) x
		left outer join 
		      ( select trunc(ff.d_period_id) d_day_id, lr.node_id, count(*) filecount
		        from   um.fmo_fileset ff,
		               um.log_record lr
		        where  ff.log_record_id = lr.log_record_id
		        and    ff.d_period_id = lr.d_period_id         
		        and    ff.d_period_id between sysdate - $lookbackdays and sysdate - 1
		        group by trunc(ff.d_period_id), lr.node_id
		      ) y
		on x.d_day_id = y.d_day_id
		and x.node_id = y.node_id
		order by x.node_id, x.d_day_id
                  )
          where  missing = 'Y'
        ";

my $sq = $dbh->prepare($SQL) or die "Couldn't prepare statement: " . $dbh->errstr;

$job->write("Executing sql to find missing node matches... ");
$sq->execute() or die "Couldn't execute statement: " . $sq->errstr;

# Loop through the missing node match jobs and execute
my $nodeJob="";
my $result="";
while(my @sql_array = $sq->fetchrow_array ) {
	
	$nodeJob = $sql_array[0];

	if ($nodeJob =~ /^jssubmitJob.*/) {
		$job->write("Executing node match job - $nodeJob");
		$result = `$nodeJob`;
		$job->write($result);
	}
}

$dbh->disconnect;

$job->write("Run missing node matches successful\n");
$job->finish();

