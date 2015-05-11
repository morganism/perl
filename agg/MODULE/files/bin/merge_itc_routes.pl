#!/usr/bin/env perl
###########################################################
# Script: Merge ITC Routes
# Author: Cartesian Limited
#
# $Revision: 1.2 $
# 
# Procedure to extract UM database reference data to a flat file 
# This is so that the aggregators can have access to the reference data 
# November 2013
#
###########################################################

use English -qw (-no_match_vars);
use strict;
use warnings;

use File::Copy;
use Scalar::Util qw(looks_like_number);

# No access to error Ascertain::Utils::exitCodes from library or from db when
# this is required so hard code this

use constant FAILED => 2;
use constant USAGE   => "Usage: merge_itc_routes.pl \"<jobId> <logFile>\" ";

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
use constant VERSION => '$Revision: 1.2 $';

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

#if (not exists $argsHash{schema})
#{
#  print USAGE . "\n";
#  exit($Ascertain::Utils::exitCodes{USAGE});
#}

#my $schema = $argsHash{schema};

my $schema = "customer";
my $table = "interconnect_routes";


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

$job->write("Starting reference data merge of $schema.$table");


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

########
# Load existing file data
########
my $itcRouteData = {};

open(ITCDAT, $filename);
while (<ITCDAT>)
{
   chomp;
   my ($inRoute, $outRoute, $flag, $desc) = split /,/;
   $inRoute =~ s/^\s+|\s+$//g;
   $outRoute =~ s/^\s+|\s+$//g;
   $flag =~ s/^\s+|\s+$//g;

   $itcRouteData->{$inRoute}->{$outRoute} = {flag=>$flag,desc=>$desc};

}
close(ITCDAT);

######
# Loop through the DB results and merge
######
while(my @sql_array = $sq->fetchrow_array ) {
   
    my $inRoute = $sql_array[0];
    my $outRoute = $sql_array[1];
    my $flag = $sql_array[2];
    my $desc = $sql_array[3];

    if ( defined $inRoute and defined $outRoute ) {
        if ( not exists $itcRouteData->{$inRoute}->{$outRoute}->{flag} ) {
            $itcRouteData->{$inRoute}->{$outRoute}->{flag} = $flag; 
            $itcRouteData->{$inRoute}->{$outRoute}->{desc} = $desc;
        }
    }
}

my $filenameTmp = $filename . "_temp";

#####
# Write merged results to temp file and DB
#####

my $deleteSQL =  "truncate table $schema.$table ";
$dbh->do($deleteSQL) or die "Failed to execite $deleteSQL " . DBI->errstr;

my $insertSQL = "insert into $schema.$table values (?,?,?,?)";

open(ITCDAT2,">",$filenameTmp); 
flock(ITCDAT2, 2);

foreach my $inRoute (keys %$itcRouteData) {
    while (my ($outRoute, $values) = each %{ $itcRouteData->{$inRoute} } ) {
		{ no warnings 'uninitialized'; 
	my $flag = $values->{flag};
	my $desc = $values->{desc};
        print ITCDAT2 "$inRoute,$outRoute,$flag,$desc\n";
        $dbh->do($insertSQL,undef,$inRoute,$outRoute,$flag,$desc); 
		}
    }
}
close(ITCDAT2);

#####
# Copy temp file back to orig file
#####

open(ITCDAT,$filename);
flock(ITCDAT,2);

if (-e $filenameTmp) {
    copy ($filenameTmp, $filename);
}
close(ITCDAT);

$dbh->disconnect();
$job->write("Merge ITC Routes successful. \n");
$job->finish();


1;
