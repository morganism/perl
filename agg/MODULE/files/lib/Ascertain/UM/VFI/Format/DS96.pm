package Ascertain::UM::VFI::Format::DS96;

use constant TRUE => 1;
use constant FALSE => undef;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);


sub init
{
	my $self = shift;

	$self->{type} = 'csv';
	$self->{delimiter} = ',';
	$self->{trim_values} = TRUE;

	$self->{has_header} = TRUE;
	$self->{skip_header_lines} = 1;
	$self->{header_regex} = qr/^ANumber/;

	$self->{has_trailer} = FALSE;
	$self->{currency_factor} = 100; # if in euros then 100, if in cents then 1
	$self->{data_factor} = 1; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		
        {name => 'ANUMBER'},
        {name => 'BNUMBER'},
        {name => 'DATETIME'},
        {name => 'DURATION'},
        {name => 'CHARGE'},
        {name => 'WCCCODE'}

	];

	$self->{format} = $format;
}



1;
