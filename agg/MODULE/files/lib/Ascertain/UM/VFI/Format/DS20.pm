package Ascertain::UM::VFI::Format::DS20;

use constant TRUE => 1;
use constant FALSE => undef;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);


sub init
{
	my $self = shift;

	$self->{type} = 'fixedwidth'; # csv fixedwidth asn1
	$self->{has_header} = FALSE;
	#$self->{skip_header_lines} = 1;
	#$self->{header_regex} = qr/^$/;
	$self->{trim_values} = TRUE;
	$self->{has_trailer} = TRUE;
	$self->{trailer_regex} = qr/^Total number of CDR's: (\d+).*/;
	$self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
	$self->{data_factor} = 1048576; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{name=>'recordtype', bytes=>2},
		{name=>'imsi', bytes=>15},
		{name=>'filler1', bytes=>3},
		{name=>'dialleddigits', bytes=>21},
		{name=>'servicetype', bytes=>2},
		{name=>'servicecode', bytes=>2},
		{name=>'filler2', bytes=>2},
		{name=>'msc_id', bytes=>15},
		{name=>'location_area_id', bytes=>5},
		{name=>'ms_class_mark', bytes=>1},
		{name=>'startdatetime', bytes=>12},
		{name=>'duration', bytes=>6},
		{name=>'data_vol', bytes=>6},
		{name=>'data_vol_ref', bytes=>6},
		{name=>'charge_sdr', bytes=>9},
		{name=>'tax_code', bytes=>1},
		{name=>'exchange_rate_code', bytes=>1},
		{name=>'filler3', bytes=>12},
	];

	$self->{format} = $format;
}


1;
