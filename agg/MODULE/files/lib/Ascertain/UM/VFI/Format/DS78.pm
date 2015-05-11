package Ascertain::UM::VFI::Format::DS78;

use constant TRUE => 1;
use constant FALSE => undef;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);


sub init
{
	my $self = shift;

	$self->{type} = 'fixedwidth'; # csv fixedwidth asn1
	$self->{has_header} = TRUE;
	$self->{skip_header_lines} = 1;
	$self->{header_regex} = qr/^10/;
	$self->{trim_values} = TRUE;
	$self->{has_trailer} = TRUE;
	$self->{trailer_regex} = qr/^90/;
	$self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
	$self->{data_factor} = 1; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{name=>'record_type', bytes=>2},
		{name=>'imsi', bytes=>15},
		{name=>'dialled_digits', bytes=>24},
		{name=>'service_type', bytes=>2},
		{name=>'service_id', bytes=>4},
		{name=>'msc_id', bytes=>15},
		{name=>'cell_id', bytes=>13},
		{name=>'station_class_mark', bytes=>1},
		{name=>'call_start_date', bytes=>6},
		{name=>'call_start_time', bytes=>6},
		{name=>'call_duration', bytes=>6},
		{name=>'data_volume', bytes=>6},
		{name=>'data_volume_ref', bytes=>6},
		{name=>'number_of_pulse', bytes=>6},
		{name=>'call_end_date', bytes=>6},
		{name=>'call_end_time', bytes=>6},
		{name=>'fill6', bytes=>31},
		{name=>'plmn', bytes=>5}
	];

	$self->{format} = $format;
}



1;
