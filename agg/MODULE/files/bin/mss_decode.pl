#! /usr/bin/perl 

use strict;
use warnings;

use File::Basename;
use IPC::Open2;
use Getopt::Long;

my $architecture = `uname`;
chomp $architecture;
my $decoder_binary = ($architecture =~ /SunOS/i) ? "ericssonR13_sparc" : "ericssonR13";

my $CHUNK_SIZE = 4096;
my $DECODER_CMD_NORMAL = $ENV{AGGREGATOR_BUILD} . "/bin/$decoder_binary - 2>/dev/null"; 
my $DECODER_CMD_DEBUG  = $ENV{AGGREGATOR_BUILD} . "/bin/ericssonR13_debug - 2>&1 "; 

my $DECODER = $DECODER_CMD_NORMAL;

my $debug = undef;
my $inputFile;
my $outputDir;
my $archiveDir;

GetOptions(

    "debug" => \$debug,
		"inputfile=s" => \$inputFile,
		"outputdir=s" => \$outputDir,
		"archivedir=s" => \$archiveDir
);

if (not defined $inputFile or not defined $outputDir)
{
	print "Usage: $0 -inputfile INPUTFILE -outputdir OUTPUTDIR -archivedir ARCHIVEDIR [-debug]\n";
	exit 1;
}
elsif (not -f $inputFile)
{
	print "INPUTFILE[$inputFile] does not exist.\n";
	exit 2;
}

my $file = $inputFile;

if( defined( $debug ) )
{
    $DECODER = $DECODER_CMD_DEBUG;
}

my $i = 0;

$|=1;

$/=undef;

# parse fileparts
my($filename, $directories, $suffix) = fileparse($file);
my $outFile = $outputDir . "/$filename.decoded";
my $tmpFile = $outputDir . "/$filename.decoded.tmp";

# ===============================
# READ INPUT FILE
# ===============================
open( INFILE , "<$file" ) or die( "Can't open $file for reading\n" );

#my $fileData = <INFILE>;



# ===============================
# PROCESS DATA BLOCKS  
# ===============================
my @data = ();
my $ptr = 0;
my $block;
my $bytesRead = 0;
my $totalBytesRead = 1;
#while( $ptr < $len ) 
while($bytesRead = read(INFILE, $block, $CHUNK_SIZE)) 
{
    #my $block = getField( $fileData , \$ptr , $CHUNK_SIZE );

    #$block =~ s/\0+$/\0/;

    #$len = length( $block );

		$totalBytesRead += $bytesRead;

    print "Processing block $i - processing $bytesRead bytes\n" if ($debug);
   
    push( @data , decodeBlock( $block ) );
 
    $i++;
}
close( INFILE ) or die( "Problem closing file handle to $file\n" );
#my $len = length( $fileData );
print "Read $totalBytesRead bytes from $file\n" if ($debug);


# ===============================
# WRITE DECODED DATA
# ===============================
my $depaddedFileData = join( "" , @data );

my $len = length( $depaddedFileData );

print "Writing $len bytes to temp file [$tmpFile]\n" if ($debug);

open( OUTFILE , ">$tmpFile" ) or die( "Can't open $tmpFile for writing\n" );

print OUTFILE "<MSS_DECODED>\n"; # need to wrap all the parts in a container
$depaddedFileData =~ s/\n\s+\n/\n/g; # strip blank lines (somehow this speeds up the XML::Simple parsing [I think])
print OUTFILE $depaddedFileData;
print OUTFILE "</MSS_DECODED>\n"; # need to wrap all the parts in a container

close( OUTFILE );
my $mvCmd = "mv $tmpFile $outFile";
print "Moving temp file [$tmpFile] to decoded file [$outFile]\n" if ($debug);
system($mvCmd);

# archive the input file
if (-e $outFile)
{
	$mvCmd = "mv $inputFile $archiveDir";
	system($mvCmd);
}


# ===============================
# SUBS 
# ===============================

sub decodeBlock
{
    my ( $buffer ) = @_;

    open2( \*READ , \*WRITE , "$DECODER" ) or die( "Can't open $file for decoding : $!\n" );

    print WRITE $buffer;

    close( WRITE );

    my $decodedBuffer = <READ>;

    close( READ );

    return $decodedBuffer;
}

sub getField
{
    my ( $buffer , $rPtr , $len ) = @_;

    print  "Not enough data in buffer to read block\n" if( $len > ( length( $buffer ) - $$rPtr ) );

    my $subStr = substr( $buffer , $$rPtr , $len );

    $$rPtr += $len;

    return $subStr;
}

