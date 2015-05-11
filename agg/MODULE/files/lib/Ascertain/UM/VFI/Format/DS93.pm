package Ascertain::UM::VFI::Format::DS93;

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
        $self->{header_regex} = qr/^File Name/;

	$self->{has_trailer} = FALSE;
	$self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
	$self->{data_factor} = 1; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[

        {name=> 'File_Name'},
        {name=> 'Provider'},
        {name=> 'From_number'},
        {name=> 'To_Number'},
        {name=> 'Event_Date'},
        {name=> 'duration_secs'},
        {name=> 'ws_cost'},
        {name=> 'info'},
        {name=> 'account_no'},
        {name=> 'rate_plan'},
        {name=> 'Classification'},
        {name=> 'SubClassification'},
        {name=> 'Display_number'},
        {name=> 'init_price_cent'},
        {name=> 'bill_cycle'},
        {name=> 'Bill_Account'},
        {name=> 'date_rated'},
        {name=> 'suspense_code'},
        {name=> 'day_key'},
        {name=> 'charge_price_cent'}
	];

	$self->{format} = $format;
}



1;
