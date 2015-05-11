#!/usr/bin/perl
###########################################################
# Script: Extract Aggregator Reference Data
# Author: Cartesian Limited
#
# $Revision: 1.1 $
# 
# Procedure to extract UM database reference data to a flat file 
# This is so that the aggregators can have access to the reference data 
# November 2013
#
###########################################################

use English -qw (-no_match_vars);
use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

# No access to error Ascertain::Utils::exitCodes from library or from db when
# this is required so hard code this

use constant FAILED => 2;
use constant USAGE   => "Usage: extract_agg_ref_data.pl \"<jobId> <logFile>\" \"-schema <schema> -table <table>\"";

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
use constant VERSION => '$Revision: 1.1 $';

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
my @extraOpts = ("schema=s","table=s");
my %argsHash = Ascertain::Utils::readArguments(USAGE, VERSION, \@ARGV, \@extraOpts);
my @debugList = (exists $argsHash{debug}) ? @{$argsHash{debug}} : ();

if (not exists $argsHash{schema})
{
  print USAGE . "\n";
  exit($Ascertain::Utils::exitCodes{USAGE});
}

if (not exists $argsHash{table})
{
  print USAGE . "\n";
  exit($Ascertain::Utils::exitCodes{USAGE});
}


my $schema = $argsHash{schema};
my $table = $argsHash{table};


##############################################
# Get passwords from .cpm.xml
##############################################

my $cpm=`grep CPM_CONFIG_FILE $ENV{CARTESIAN_PROPERTIES} | awk '{print \$2}' FS="="`;

open(IN,$cpm) or die "Could not cpm password file $cpm\n";;

my @line = [];
my @parts = [];
my $passwords = {};

my $user = "";
my $pass = "";

while(<IN>) {
        chomp;
        @line = split /\s+/, $_;

        foreach my $part (@line) {
                if ($part =~ /user=/) {
                        @parts = split /=/, $part;
                        $user = $parts[1];
                        $user =~ s/"//g;
                }
                if ($part =~ /password=/) {
                        @parts = split /=/, $part;
                        $pass = $parts[1];
                        $pass =~ s/"//g;
                }
        }

        if ($pass ne "" and $user ne "") {
                $passwords->{$user} = $pass;
                $user="";
                $pass="";
        }
}


###########################################################
# Create a Job object for given job id
###########################################################
my $dbUsername = "jobs";
my $dbPassword = $passwords->{jobs};

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

$job->write("Starting reference data extraction of $schema.$table");


$dbUsername = $schema; 
$dbPassword = $passwords->{$schema};

my $dbh = DBI->connect("dbi:Oracle:$ENV{ORACLE_SID}",
                          $dbUsername, $dbPassword,
                          { PrintError => 0, RaiseError => 0});

if (!$dbh)
{
  $job->write("Failed to connect to database as user $dbUsername\n");
  exit($Ascertain::Utils::exitCodes{DB});
}

my $SQL = "select *
           from  $schema.$table  ";  

my $sq = $dbh->prepare($SQL) or die "Couldn't prepare statement: " . $dbh->errstr;

$job->write("Executing sql to extract table data ... ");
$sq->execute() or die "Couldn't execute statement: " . $sq->errstr;


my $filename = $ENV{ASCERTAIN_DATA} . "/aggregator/data/" . $table . ".dat";

my $fh;
open ($fh,">", $filename) or die "Could not open output file $filename\n";

# Loop through the results and print
while(my @sql_array = $sq->fetchrow_array ) {
	print $fh do { no warnings 'uninitialized'; join ',', @sql_array; };
	print $fh "\n";
}

close($fh);
$dbh->disconnect;

$job->write("Extract Aggregator reference data for $schema.$table successful. \n");
$job->finish();

1;
