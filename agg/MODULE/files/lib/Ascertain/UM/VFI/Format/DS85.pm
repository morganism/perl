package Ascertain::UM::VFI::Format::DS85;

use constant TRUE => 1;
use constant FALSE => undef;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);

sub init
{
	my $self = shift;

	$self->{type} = 'fixedwidth';
	$self->{has_header} = TRUE;
	$self->{skip_header_lines} = 1;
	$self->{header_regex} = qr/^10/;
	$self->{trim_values} = TRUE;
	$self->{has_trailer} = TRUE;
	$self->{trailer_regex} = qr/^90/;
	$self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
	$self->{data_factor} = 1048576; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{
			name => 'RECORD_TYPE',
			bytes => 2,
			type => 'TEXT'
		},
		{
			name => 'CONT_FLAG',
			bytes => 1,
			type => 'TEXT'
		},
		{
			name => 'CONTEXT_PART_ID',
			bytes => 10,
			type => 'TEXT'
		},
		{
			name => 'CORR_ID',
			bytes => 10,
			type => 'TEXT'
		},
		{
			name => 'IMSI',
			bytes => 15,
			type => 'TEXT'
		},
		{
			name => 'MSISDN',
			bytes => 18,
			type => 'TEXT'
		},
		{
			name => 'IMEI',
			bytes => 15,
			type => 'TEXT'
		},
		{
			name => 'PDP_TYPE',
			bytes => 4,
			type => 'TEXT'
		},
		{
			name => 'PDP_ADDR',
			bytes => 32,
			type => 'TEXT'
		},
		{
			name => 'DYN_FLAG',
			bytes => 1,
			type => 'TEXT'
		},
		{
			name => 'APN',
			bytes => 64,
			type => 'TEXT'
		},
		{
			name => 'APN_ID',
			bytes => 4,
			type => 'TEXT'
		},
		{
			name => 'SGSN_ADDR',
			bytes => 15,
			type => 'TEXT'
		},
		{
			name => 'CELL_ID',
			bytes => 13,
			type => 'TEXT'
		},
		{
			name => 'GGSN_ADDR',
			bytes => 15,
			type => 'TEXT'
		},
		{
			name => 'OP_CELL_ID',
			bytes => 13,
			type => 'TEXT'
		},
		{
			name => 'CALL_START_DATETIME',
			bytes => 12,
			type => 'YYMMDDHHMMSS'
		},
		{
			name => 'CALL_END_DATETIME',
			bytes => 12,
			type => 'YYMMDDHHMMSS'
		},
		{
			name => 'CALL_DURATION',
			bytes => 12,
			type => 'TEXT'
		},
		{
			name => 'DATA_VOLUME',
			bytes => 12,
			type => 'TEXT'
		},
		{
			name => 'DATA_VOLUME_DOWNLINK',
			bytes => 12,
			type => 'TEXT'
		},
		{
			name => 'ORIGINATOR_FLAG',
			bytes => 1,
			type => 'TEXT'
		},
		{
			name => 'QUALITY_OF_MEASURE',
			bytes => 1,
			type => 'TEXT'
		},
		{
			name => 'CAUSE_FOR_TERMINATION',
			bytes => 1,
			type => 'TEXT'
		},
		{
			name => 'LOCATION_OF_TERMINATION',
			bytes => 2,
			type => 'TEXT'
		},
		{
			name => 'CALL SERVICE TYPE',
			bytes => 2,
			type => 'TEXT'
		},
		{
			name => 'CALL SERVICE CODE',
			bytes => 4,
			type => 'TEXT'
		},
		{
			name => 'PLMN_CODE',
			bytes => 5,
			type => 'TEXT'
		},
		{
			name => 'CALL_RETAIL_PRICE',
			bytes => 10,
			type => 'Numeric'
		},
		{
			name => 'CALL_DISCOUNT',
			bytes => 10,
			type => 'Numeric'
		},
		{
			name => 'CALL_PP_ALLOWANCE',
			bytes => 10,
			type => 'Numeric'
		},
		{
			name => 'CALL_BREAKDOWN_CODE',
			bytes => 5,
			type => 'TEXT'
		},
		{
			name => 'CALL_BUNDLE_ID_01',
			bytes => 15,
			type => 'TEXT'
		},
		{
			name => 'CALL_BUNDLE_USAGE_01',
			bytes => 17,
			type => 'Numeric'
		},
		{
			name => 'CALL_BUNDLE_ID_02',
			bytes => 15,
			type => 'TEXT'
		},
		{
			name => 'CALL_BUNDLE_USAGE_02',
			bytes => 17,
			type => 'Numeric'
		},
		{
			name => 'CALL_BUNDLE_ID_03',
			bytes => 15,
			type => 'TEXT'
		},
		{
			name => 'CALL_BUNDLE_USAGE_03',
			bytes => 17,
			type => 'Numeric'
		},
		{
			name => 'CALL_BUNDLE_ID_04',
			bytes => 15,
			type => 'TEXT'
		},
		{
			name => 'CALL_BUNDLE_USAGE_04',
			bytes => 17,
			type => 'Numeric'
		}
	];

	$self->{format} = $format;
}

1;
