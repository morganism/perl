package Ascertain::UM::VFI::MultiFormat;

use Data::Dumper;
use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);

use constant TRUE => 1;
use constant FALSE => undef;

sub setFormat
{
	my $self = shift;
	my $lable = shift;
	$self->{format} = $self->{formats}->{$lable};
}
	

sub isMultiFormat
{
	my $self = shift;
	return TRUE;
}	
1;
