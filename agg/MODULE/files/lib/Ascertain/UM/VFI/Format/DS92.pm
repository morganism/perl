package Ascertain::UM::VFI::Format::DS92;

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

	$self->{has_header} = FALSE;
	$self->{skip_header_lines} = 0;

	$self->{has_trailer} = FALSE;
	$self->{currency_factor} = 100; # if in euros then 100, if in cents then 1
	$self->{data_factor} = 1; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		
        {name => 'Anum'},
        {name => 'CallTime'},
        {name => 'SD'},
        {name => 'ServiceDescription '},
        {name => 'Bnum'},
        {name => 'SecsA'},
        {name => 'X1'},
        {name => 'ChgA'},
        {name => 'Rate'},
        {name => 'X2'},
        {name => 'X3'},
        {name => 'Cnum'},
        {name => 'X4'}

	];

	$self->{format} = $format;
}



1;
