package Ascertain::UM::VFI::Format::D57;

use constant TRUE => 1;
use constant FALSE => undef;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);

sub init
{
	my $self = shift;

	$self->{type} = 'fixedwidth';
	$self->{has_header} = TRUE;
#	$self->{skip_header_lines} = 1;
#	$self->{header_regex} = qr/^10/;
	$self->{trim_values} = TRUE;
#	$self->{has_trailer} = TRUE;
#	$self->{trailer_regex} = qr/^90/;
	$self->{currency_factor} = 100; # if in euros then 100, if in cents then 1
	$self->{data_factor} = 1048576; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{
			name => 'customer_number',
			bytes => 10,
			type => 'Numeric'
		},
		{
			name => 'subscriber_number',
			bytes => 10,
			type => 'Numeric'
		},
		{
			name => 'bill_date',
			bytes => 11,
			type => 'TEXT'
		},
		{
			name => 'package_plan_code',
			bytes => 5,
			type => 'TEXT'
		},
		{
			name => 'call_breakdown_code',
			bytes => 5,
			type => 'TEXT'
		},
		{
			name => 'call_class',
			bytes => 5,
			type => 'TEXT'
		},
		{
			name => 'call_start_date',
			bytes => 11,
			type => 'TEXT'
		},
		{
			name => 'call_start_time',
			bytes => 8,
			type => 'TEXT'
		},
		{
			name => 'call_duration',
			bytes => 8,
			type => 'Numeric'
		},
		{
			name => 'call_service_type',
			bytes => 2,
			type => 'TEXT'
		},
		{
			name => 'call_service_code',
			bytes => 2,
			type => 'TEXT'
		},
		{
			name => 'call_service_mod',
			bytes => 2,
			type => 'TEXT'
		},
		{
			name => 'call_net_price',
			bytes => 10,
			type => 'Numeric'
		},
		{
			name => 'call_retail_price',
			bytes => 10,
			type => 'Numeric'
		},
		{
			name => 'call_discount_price',
			bytes => 10,
			type => 'Numeric'
		},
		{
			name => 'call_location',
			bytes => 13,
			type => 'TEXT'
		},
		{
			name => 'call_dialled_digits',
			bytes => 12,
			type => 'TEXT'
		},
		{
			name => 'nominal_ledger_code',
			bytes => 12,
			type => 'TEXT'
		},
		{
			name => 'call_record_type',
			bytes => 2,
			type => 'TEXT'
		},
		{
			name => 'call_category',
			bytes => 5,
			type => 'TEXT'
		},
		{
			name => 'call_data_vol',
			bytes => 11,
			type => 'Numeric'
		},
		{
			name => 'call_plmn_code',
			bytes => 5,
			type => 'TEXT'
		},
	];

	$self->{format} = $format;
}

1;
