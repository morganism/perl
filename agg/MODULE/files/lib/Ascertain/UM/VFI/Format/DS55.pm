package Ascertain::UM::VFI::Format::DS55;

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
  $self->{data_factor} = 1048576; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{
			name => 'RECORD_TYPE',
			bytes => '2'
		},
		{
			name => 'CONT_FLAG',
			bytes => '1'
		},
		{
			name => 'CONTEXT_PART_ID',
			bytes => '10'
		},
		{
			name => 'CORR_ID',
			bytes => '10'
		},
		{
			name => 'IMSI',
			bytes => '15'
		},
		{
			name => 'MSISDN',
			bytes => '18'
		},
		{
			name => 'IMEI',
			bytes => '15'
		},
		{
			name => 'PDP_TYPE',
			bytes => '4'
		},
		{
			name => 'PDP_ADDR',
			bytes => '32'
		},
		{
			name => 'DYN_FLAG',
			bytes => '1'
		},
		{
			name => 'APN',
			bytes => '64'
		},
		{
			name => 'APN_ID',
			bytes => '4'
		},
		{
			name => 'SGSN_ADDR',
			bytes => '15'
		},
		{
			name => 'CELL_ID',
			bytes => '13'
		},
		{
			name => 'GGSN_ADDR',
			bytes => '15'
		},
		{
			name => 'OP_CELL_ID',
			bytes => '13'
		},
		{
			name => 'CALL_START_DATETIME',
			bytes => '12'
		},
		{
			name => 'CALL_END_DATETIME',
			bytes => '12'
		},
		{
			name => 'CALL_DURATION',
			bytes => '12'
		},
		{
			name => 'DATA_VOLUME',
			bytes => '12'
		},
		{
			name => 'DATA_VOLUME_DOWNLINK',
			bytes => '12'
		},
		{
			name => 'ORIGINATOR_FLAG',
			bytes => '1'
		},
		{
			name => 'QUALITY_OF_MEASURE',
			bytes => '1'
		},
		{
			name => 'CAUSE_FOR_TERMINATION',
			bytes => '1'
		},
		{
			name => 'LOCATION_OF_TERMINATION',
			bytes => '2'
		},
		{
			name => 'CALL_SERVICE_TYPE',
			bytes => '2'
		},
		{
			name => 'CALL_SERVICE_CODE',
			bytes => '2'
		},
		{
                        name => 'CALL_SERVICE_CODE_FILLER',
                        bytes => '2'
                },
		{
			name => 'PLMN_CODE',
			bytes => '5'
		}
	];

	$self->{format} = $format;
}



1;
