#! /usr/bin/perl 

use strict;
use warnings;

use File::Basename;
use IPC::Open2;
use Getopt::Long;

my $inputFile;
my $outRatedDir;
my $outSuspenseDir;
my $outSuspenseHistDir;
my $archiveDir;
my $tmpDir;
my $errDir;
my $debug;

GetOptions(
		"debug" => \$debug,
		"inputfile=s" => \$inputFile,
		"outRatedDir=s" => \$outRatedDir,
		"outSuspenseDir=s" => \$outSuspenseDir,
		"outSuspenseHistDir=s" => \$outSuspenseHistDir,
		"archivedir=s" => \$archiveDir,
		"tmpdir=s" => \$tmpDir,
	 	"errdir=s" => \$errDir
);

if (not defined $inputFile or not defined $outRatedDir or not defined $outSuspenseDir or not defined $outSuspenseHistDir or not defined $tmpDir or not defined $errDir )
{
	print "SSRated_pp.pl: Usage: $0 -inputfile INPUTFILE -outRatedDir OUTRATEDDIR -outSuspenseDir OUTSUSPENSEDIR -outSuspenseHistDir OUTSUSPENSEHISTDIR -archivedir ARCHIVEDIR -tmpdir TMPDIR -errdir ERRDIR \n";
	exit 1;
}
elsif (not -f $inputFile)
{
	print "SSRated_pp.pl: INPUTFILE[$inputFile] does not exist.\n";
	exit 2;
}

my($filename, $directories, $suffix) = fileparse($inputFile);

my $outRatedFile = $outRatedDir . "/$filename.rated";
my $outSuspenseFile = $outSuspenseDir . "/$filename.suspense";
my $outSuspenseHistFile = $outSuspenseHistDir . "/$filename.suspenseHist";

my $tmpRatedFile = $tmpDir . "/$filename.rated.tmp";
my $tmpSuspFile = $tmpDir . "/$filename.susp.tmp";


# Check for a 0 value in the suspense_code column (3rd from the end)
system("grep \"^File Name\" $inputFile > $tmpRatedFile");
my $ratedCMD = "grep \",0,[^,]*,[^,]*\$\" $inputFile >> $tmpRatedFile ";
my $suspenseCMD = "grep -v \",0,[^,]*,[^,]*\$\" $inputFile > $tmpSuspFile ";

my $PreProcessFailed=0;

my $CMDRES  = system($ratedCMD); 
my $CMDRES2 = system($suspenseCMD);

#if ($CMDRES != 0 || $CMDRES2 != 0) {
#	$PreProcessFailed=1;
#}

# Do validation
my ($inCount, $RatedCount, $SuspenseCount);
my ($file, $tmpst);
my @tmpA;

$tmpst = `wc -l $inputFile`;
@tmpA = split /\s+/,$tmpst;
$inCount = $tmpA[0];

$tmpst = `wc -l $tmpRatedFile`;
@tmpA = split /\s+/,$tmpst;
$RatedCount = $tmpA[0];

$tmpst = `wc -l $tmpSuspFile`;
@tmpA = split /\s+/,$tmpst;
$SuspenseCount = $tmpA[0];


if ($inCount != $RatedCount + $SuspenseCount - 1) {
	$PreProcessFailed=1;
}

if (!$PreProcessFailed) {
	my $mvCmd;
	my $cpCmd;

	if (-e $tmpSuspFile) {
		$mvCmd = "mv $tmpSuspFile $outSuspenseFile";
		system($mvCmd);
		if ($? != 0) {
			print "Error: Failed to move temp suspense file to Output Dir ($mvCmd) - $!\n";
			print "Removing all temp files\n";
			system("rm $tmpSuspFile $tmpRatedFile");
			exit 1;
		}
	
		$cpCmd = "cp $outSuspenseFile $outSuspenseHistFile";
        system($cpCmd);
        if ($? != 0) {
            print "Error: Failed to copy suspense file to Suspense Hist Output Dir ($cpCmd) - $!\n";
            print "Removing all temp and output files\n";
            system("rm $tmpSuspFile $tmpRatedFile $outSuspenseFile");
            exit 1;
        }			
	}

	if (-e $tmpRatedFile) {
		$mvCmd = "mv $tmpRatedFile $outRatedFile";
        system($mvCmd);
        if ($? != 0) {
            print "Error: Failed to move temp rated file to Output Dir ($mvCmd) - $!\n";
            print "Removing all temp files\n";
            system("rm $tmpSuspFile $tmpRatedFile $outSuspenseFile $outSuspenseHistFile");
            exit 1;
        }
	}

	$mvCmd = "mv $inputFile $archiveDir";
	system($mvCmd);
	if ($? != 0) {
		print "Error: Failed to move inputFile to archiveDir ($mvCmd) - $!\n";
		print "Removing all output files\n";
		system("rm $outSuspenseFile $outSuspenseHistFile $outRatedFile");
		exit 1;
    }
}
else {
	system("rm $tmpSuspFile $tmpRatedFile");
	my $errFile = $errDir . "/$filename.decode_err";

    my $mvCmd = "mv $inputFile $errFile";
    system($mvCmd);

    print "Error: Preprocessor reported failure. \n";
    exit 1;
}

exit 0;

