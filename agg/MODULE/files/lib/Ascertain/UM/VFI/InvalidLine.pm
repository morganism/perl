package Ascertain::UM::VFI::InvalidLine;

use constant TRUE => 1;
use constant FALSE => undef;

sub new
{
	my $proto = shift;
	my $class = ref $proto || $proto;
	my $self = {};
	my $args = shift;
	$self->{line_number} = $args->{line_number};
	$self->{data} = $args->{data};
	$self->{logger} = $args->{logger};
	$self->{debugger} = $args->{debugger};

	bless $self, $class;
	return $self;
}

sub getLineNumber
{
	my $self = shift;
	return $self->{line_number}
}

sub getData
{
	my $self = shift;
	return $self->{data}
}

1;
