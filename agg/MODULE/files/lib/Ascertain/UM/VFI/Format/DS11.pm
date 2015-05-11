package Ascertain::UM::VFI::Format::DS11;

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
	$self->{trim_values} = TRUE;
  $self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
  $self->{data_factor} = 1; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{
			name => 'Record_Type',
			bytes => 2
		},
		{
			name => 'IMSI',
			bytes => 15
		},
		{
			name => 'Dialled_Digits',
			bytes => 24
		},
		{
			name => 'Service_Type',
			bytes => 2
		},
		{
			name => 'Service_Id',
			bytes => 4
		},
		{
			name => 'MSC_Id',
			bytes => 15
		},
		{
			name => 'Cell_Id',
			bytes => 13
		},
		{
			name => 'Station_Class_Mark',
			bytes => 1
		},
		{
			name => 'Call_Start_Date',
			bytes => 6
		},
		{
			name => 'Call_Start_Time',
			bytes => 6
		},
		{
			name => 'Call_Duration',
			bytes => 6
		},
		{
			name => 'Data_Volume',
			bytes => 12
		},
		{
			name => 'Number_of_pulse',
			bytes => 6
		},
		{
			name => 'Call_End_Date',
			bytes => 6
		},
		{
			name => 'Call_End_Time',
			bytes => 6
		},
		{
			name => 'Fill6_Ascii',
			bytes => 4
		},
		{
			name => 'Term_MSC_ID',
			bytes => 15
		},
		{
			name => 'Term_Cell_ID',
			bytes => 13
		},
		{
			name => 'PLMN_Code',
			bytes => 5
		},
		{
			name => 'BLANK',
			bytes => 1
		}
	];

	$self->{format} = $format;
}



1;
