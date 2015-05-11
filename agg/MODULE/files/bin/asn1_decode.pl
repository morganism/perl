#! /usr/bin/perl 

use strict;
use warnings;

use File::Basename;
use IPC::Open2;
use Getopt::Long;

my $architecture = `uname`;
chomp $architecture;

my $mss_decoder_binary = ($architecture =~ /SunOS/i) ? "ericssonR13_sparc" : "ericssonR13";
my $pgw_decoder_binary = "PGW_decoder";
my $sgw_decoder_binary = "SGW_decoder";
my $sgsn_decoder_binary = "SGSN_decoder";
my $decoder_binary;

my $debug = undef;
my $inputFile;
my $outputDir;
my $archiveDir;
my $tmpDir;
my $errDir;
my $doByChunks;
my $format = "";


GetOptions(
		"debug" => \$debug,
		"inputfile=s" => \$inputFile,
		"outputdir=s" => \$outputDir,
		"archivedir=s" => \$archiveDir,
		"tmpdir=s" => \$tmpDir,
	 	"errdir=s" => \$errDir,
		"format=s" => \$format,
		"processChunks" => \$doByChunks
);

if ($format eq "PGW" ) 
{
	$decoder_binary = $pgw_decoder_binary;
}
elsif ($format eq "SGW" )
{
        $decoder_binary = $sgw_decoder_binary;
}
elsif ($format eq "SGSN" )
{
        $decoder_binary = $sgsn_decoder_binary;
}
elsif ($format eq "MSS" )
{
        $decoder_binary = $mss_decoder_binary;
}
else 
{
	$decoder_binary = undef;
}

if (not defined $inputFile or not defined $outputDir or not defined $decoder_binary or not defined $tmpDir or not defined $errDir )
{
	print "asn1_decoder.pl: Usage: $0 -inputfile INPUTFILE -outputdir OUTPUTDIR -archivedir ARCHIVEDIR -tmpdir TMPDIR -errdir ERRDIR -format [PGW|SGW|SGSN|MSS] (-processChunks)\n";
	exit 1;
}
elsif (not -f $inputFile)
{
	print "asn1_decoder.pl: INPUTFILE[$inputFile] does not exist.\n";
	exit 2;
}

my($filename, $directories, $suffix) = fileparse($inputFile);

#my $DECODER = $ENV{AGGREGATOR_BUILD} . "/bin/$decoder_binary - 2>/dev/null";
my $DECODER = $ENV{AGGREGATOR_BUILD} . "/bin/$decoder_binary 2>&1";

my $outFile = $outputDir . "/$filename.decoded";
my $tmpFile = $tmpDir . "/$filename.tmp";


print "asn1_decoder.pl: Using decoder $decoder_binary on file $filename\n";

open(OUT, ">$tmpFile") or die "Failed to open file in tmpDir ($tmpFile): $! \n";
print OUT "<" . $format . "_DECODED>\n";

my $numLines=0;
my $decodeFailed=0;
my $line;

if ($doByChunks) {

	my $CHUNK_SIZE=4096;
	my $wrkFile = $tmpDir . "/$filename.wrk";
	my $bytesRead;
	my $block;

	open(IN,"$inputFile") or die "Failed to open work file ($inputFile) : $! \n";

	while($bytesRead = read(IN, $block, $CHUNK_SIZE))
	{
		open(WRK,">$wrkFile") or die "Failed to open work file ($wrkFile): $! \n";
		print WRK $block;
		close(WRK);
		
		open(DCD, "$DECODER $wrkFile |") or die "Failed to initiate decoder ($DECODER): $!\n";
        	while ($line = <DCD>) {

               		# Print decoded line if it looks like XML
               		if ( $line =~ /^\s*<.*>\s*$/ or $line =~ /^\s*[0-9]+$/)
                	{
                        	print OUT "$line";
                        	$numLines++;
                	}

               		# Ignore blank lines
               		elsif ( $line =~ /^\s*$/)
                	{
                        	# do nothing
                	}
        	}
        	close(DCD);
		unlink($wrkFile);
	}
	close(IN);
}
else {
	
	open(DCD, "$DECODER $inputFile |") or die "Failed to initiate decoder ($DECODER): $!\n";

	while ($line = <DCD>) {

 	    	# Print decoded line if it looks like XML
 	       if ( $line =~ /^\s*<.*>\s*$/ or $line =~ /^\s*[0-9]+$/) 
  	  	{
			print OUT "$line";   
 			$numLines++;
 		} 

 	       # Ignore blank lines
 	       elsif ( $line =~ /^\s*$/) 
		{
 			# do nothing
		}

 	       # Report anything else
        	else {
			print "Error: Invalid output from decoder: $line \n";
 			if ($line =~ /Decode failed/) {
				$decodeFailed=1;
			}
		}
	}
	close(DCD);

}

print OUT "</" . $format . "_DECODED>\n";
close(OUT);


if (-e $tmpFile && !$decodeFailed && $numLines > 0)
{
        my $mvCmd = "mv $tmpFile $outFile";
	system($mvCmd);

        if (-e $outFile ) {
		$mvCmd = "mv $inputFile $archiveDir";
		system($mvCmd);
		
		if ($? != 0) {
			print "Error: Failed to move inputFile to archiveDir ($mvCmd) - $!\n";
			print "Removing output file\n";
			system("rm $outFile");
		 	exit 1;
		}
                else {
			print "asn1_decoder.pl: Processed $numLines lines\n";
		}
	}
	else {
		print "Error: Failed to create output file ($outFile) - $!\n";
		system("rm $tmpFile");
		exit 1;
	}
}
else {
        system("rm $tmpFile");
		my $errFile = $errDir . "/$filename.decode_err";
    
		my $mvCmd = "mv $inputFile $errFile";
		system($mvCmd);

		print "Error: Decoder reported failure. \n";
        exit 1;
}

exit 0;

