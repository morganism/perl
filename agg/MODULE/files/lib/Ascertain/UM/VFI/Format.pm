package Ascertain::UM::VFI::Format;
use Data::Dumper;

use constant TRUE => 1;
use constant FALSE => undef;

sub new
{
	my $proto = shift;
	my $class = ref $proto || $proto;
	my $self = {};
	my $args = shift;
	my $ds = $args->{data_source};
	$self->{data_source} = $ds;
	$self->{logger} = $args->{logger};
	$self->{debugger} = $args->{debugger};
	my $subClass = "Ascertain::UM::VFI::Format::$ds";
	bless $self, $subClass;
	$self->{debugger}("Subclassing this class as : $subClass");
	$self->{logger}("Creating Format -> $subClass");
	$self->init(); # set the $self->{format} or anything else
	return $self;
}

# make sure users of this super class get it right
# subClass must override this
sub init { my $self = shift; die "init() NOT DEFINED IN SUBCLASS: Format/$self->{data_source}.pm" };
sub setFormat {my $self = shift; die "setFormat() NOT DEFINED IN SUBCLASS Format/$self->{data_source}.pm" };

sub getDataFactor
{
	my $self = shift;
	return $self->{data_factor};
}

sub getCurrencyFactor
{
	my $self = shift;
	return $self->{currency_factor};
}

sub getFormat
{
	my $self = shift;
	return $self->{format};
}


sub getType
{
	my $self = shift;
	return $self->{type};
}

sub getDelimiter
{
	my $self = shift;
	my $d = $self->{delimiter};

	die "Format configuration exception must define \$self->{delimiter} in CSV formats."
		if ($self->{type} eq "csv" and not defined $d);
	
	return $d;
}

sub hasTrailer
{
	my $self = shift;
	return $self->{has_trailer};
}

sub getTrailerRegex
{
	my $self = shift;
	return $self->{trailer_regex};
}

sub hasHeader
{
	my $self = shift;
	return $self->{has_header};
}

sub getHeaderRegex
{
	my $self = shift;
	return $self->{header_regex};
}

sub getSkipHeaderLines
{
	my $self = shift;
	return $self->{skip_header_lines};
}

sub isLenient
{
	my $self = shift;
	return $self->{lenient};
}

sub isMultiFormat
{
	my $self = shift;
	return FALSE;
}	

1;
