package Ascertain::UM::VFI::Format::DS40;

use constant TRUE => 1;
use constant FALSE => undef;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);


#--- !!!!!!!!!!!! Just a hust to be replaced

sub init
{
	my $self = shift;

	$self->{type} = 'fixedwidth'; # csv fixedwidth asn1
	$self->{has_header} = TRUE;
	$self->{skip_header_lines} = 1;
	#$self->{header_regex} = qr/^$/;
	#$self->{trim_values} = TRUE;
	$self->{has_trailer} = TRUE;
	$self->{trailer_regex} = qr/^90/;
	$self->{lenient} = TRUE;
	$self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
  $self->{data_factor} = 1; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{name => 'filler1', bytes => 234},
		{name => 'startDateTime', bytes => 12},
		{name => 'endDateTime', bytes => 12},
		{name => 'filler2', bytes => 47},
		{name => 'revenue', bytes => 5},
		{name => 'filler3', bytes => 49},
	];

	$self->{format} = $format;
}



1;
