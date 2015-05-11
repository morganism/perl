package Ascertain::UM::VFI::Format::DS39;

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
			name => 'RecordType',
			bytes => '2'
		},
		{
			name => 'Served_IMSI',
			bytes => '15'
		},
		{
			name => 'APN_Prefix',
			bytes => '1'
		},
		{
			name => 'AccessPointName',
			bytes => '23'
		},
		{
			name => 'ServiceCode',
			bytes => '4'
		},
		{
			name => 'Service_Filler',
			bytes => '2'
		},
		{
			name => 'SGSNAddressList',
			bytes => '15'
		},
		{
			name => 'OrigCellID',
			bytes => '13'
		},
		{
			name => 'StationClassMark',
			bytes => '1'
		},
		{
			name => 'StartTime',
			bytes => '12'
		},
		{
			name => 'TAP1_Call_Duration',
			bytes => '6'
		},
		{
			name => 'TAP1_DataVolume',
			bytes => '12'
		},
		{
			name => 'DataVolRef',
			bytes => '6'
		},
		{
			name => 'No_Of_Pulse',
			bytes => '6'
		},
		{
			name => 'DateTime',
			bytes => '12'
		},
		{
			name => 'Filler',
			bytes => '4'
		},
		{
			name => 'Term_MSC_ID',
			bytes => '15'
		},
		{
			name => 'Term_Cell_ID',
			bytes => '7'             # spec says 13 but it works with 7
		},
		{
			name => 'VFI_Field',
			bytes => '7'             # field has appeared: 20110331
		}
	];

	$self->{format} = $format;
}



1;
