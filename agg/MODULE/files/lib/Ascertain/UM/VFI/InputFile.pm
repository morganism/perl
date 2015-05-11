package Ascertain::UM::VFI::InputFile;

use Data::Dumper;

use constant TRUE => 1;
use constant FALSE => undef;
use constant UNKNOWN => "UNKNOWN";


sub new
{
	my $proto = shift;
	my $class = ref $proto || $proto;
	my $self = {};
	my $args = shift;
	$self->{full_path} = $args->{full_path};
	$self->{neid} = $args->{neid};
	$self->{pre_post} = (defined $args->{pre_post}) ? $args->{pre_post} : UNKNOWN;
	$self->{edr_file_name} = $args->{edr_file_name};
	$self->{current_dir} = $args->{current_dir};
	$self->{logger} = $args->{logger};
	$self->{debugger} = $args->{debugger};
	$self->{file_number} = $args->{file_number};
	$self->{format_obj} = $args->{format_obj};

	# control totals 'lc' eq line count
	$self->{lc_total} = 0;
	$self->{lc_header} = 0;
	$self->{lc_trailer} = 0;
	$self->{lc_invalid} = 0;
	$self->{lc_aggregated} = 0;

	bless $self, $class;
	return $self;
}

sub setFormatObj
{
	my $self = shift;
	$self->{format_obj} = shift;
}

sub getFullPath
{
	my $self = shift;
	return $self->{full_path}
}

sub setFullPath
{
	my $self = shift;
	$self->{full_path} = shift;
}

sub getCurrentDir
{
	my $self = shift;
	return $self->{current_dir};
}

sub setCurrentDir
{
	my $self = shift;
	$self->{current_dir} = shift;
}

# did file pass validity checks , if so the aggregation results can be used
sub isValid
{
	my $self = shift;
	return $self->{is_valid};
}
sub setIsValid
{
	my $self = shift;
	$self->{is_valid} = TRUE;
}
sub setNotValid
{
	my $self = shift;
	$self->{is_valid} = FALSE;
}

sub getNeId
{
	my $self = shift;
	return $self->{neid}
}

sub getEdrFileName
{
	my $self = shift;
	return $self->{edr_file_name};
}

sub getPrePost
{
	my $self = shift;
	return $self->{pre_post};
}

sub getFileNumber
{
	my $self = shift;
	return $self->{file_number};
}


#--------------------------------------------
# CONTROL TOTALS
#
# X = H + T + I + A
#--------------------------------------------

# total count of all records read
# X
sub setTotalLineCount
{
	my $self = shift;
	$self->{lc_total} = shift;
}
sub getTotalLineCount
{
	my $self = shift;
	return $self->{lc_total};
}
sub incrementTotalLineCount
{
	my $self = shift;
	$self->{lc_total}++;
}

# count of records deemed to be headers
# H
sub setHeaderLineCount
{
	my $self = shift;
	$self->{lc_header} = shift;
}
sub getHeaderLineCount
{
	my $self = shift;
	return $self->{lc_header};
}
sub incrementHeaderLineCount
{
	my $self = shift;
	$self->{lc_header}++;
}

# count of records deemed to be trailers
# T
sub setTrailerLineCount
{
	my $self = shift;
	$self->{lc_trailer} = shift;
}
sub getTrailerLineCount
{
	my $self = shift;
	return $self->{lc_trailer};
}
sub incrementTrailerLineCount
{
	my $self = shift;
	$self->{lc_trailer}++;
}

# total count of invalids, not head or trail
# I
sub setInvalidLineCount
{
	my $self = shift;
	$self->{lc_invalid} = shift;
}
sub getInvalidLineCount
{
	my $self = shift;
	return $self->{lc_invalid};
}
sub incrementInvalidLineCount
{
	my $self = shift;
	$self->{lc_invalid}++;
}
sub decrementInvalidLineCount
{
	my $self = shift;
	$self->{lc_invalid}--;
}

# count of parsed edr records that made it to agg count
# A
sub setAggregatedLineCount
{
	my $self = shift;
	$self->{lc_aggregated} = shift;
}
sub getAggregatedLineCount
{
	my $self = shift;
	return $self->{lc_aggregated};
}
sub incrementAggregatedLineCount
{
	my $self = shift;
	$self->{lc_aggregated}++;
}
sub decrementAggregatedLineCount
{
	my $self = shift;
	$self->{lc_aggregated}--;
}

sub printStats
{
	my $self = shift;	
	my $x = $self->{lc_total};
	my $a = $self->{lc_aggregated};
	my $h = $self->{lc_header};
	my $t = $self->{lc_trailer};
	my $i = $self->{lc_invalid};
	my $c = $x - ($a + $h + $t + $i);

	my $valid = (defined $self->{is_valid}) ? "VALID" : "NOT VALID";

	my $inputDir = $self->{current_dir};
	my $edrFileName = $self->{edr_file_name};

	my $headerLable = "H: HEADER COUNT ";
	my $trailerLable = "T: TRAILER COUNT";
	if ($self->{format_obj}->hasHeader())
	{
		$headerLable = $headerLable .= " *";
	}
	if ($self->{format_obj}->hasTrailer())
	{
		$trailerLable = $trailerLable .= " *";
	}

	my $separator = "-" x 80;	
	$self->{logger}($separator);
	$self->{logger}(sprintf "%-80s",$valid);
	$self->{logger}(sprintf "%-60s%20s",$edrFileName, "");
	$self->{logger}(sprintf "%-60s%20s",$inputDir, "");
	$self->{logger}($separator);
	$self->{logger}(sprintf "%-60s%20s","X: TOTAL RECORDS",$x);
	$self->{logger}($separator);
	$self->{logger}(sprintf "%-60s%20s","A: AGGREGATED RECORDS",$a);
	$self->{logger}(sprintf "%-60s%20s",$headerLable,$h);
	$self->{logger}(sprintf "%-60s%20s",$trailerLable,$t);
	$self->{logger}(sprintf "%-60s%20s","I: INVALID COUNT",$i);
	$self->{logger}($separator);
	$self->{logger}(sprintf "%-60s%20s","C: CONTROL TOTAL",$c);
	$self->{logger}($separator);
	$self->{logger}("");
	$self->{logger}("");
}


1;
