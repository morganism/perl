package Ascertain::UM::VFI::Format::DS64;

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
  #$self->{trim_values} = TRUE;
  $self->{has_trailer} = TRUE;
  $self->{trailer_regex} = qr/^90\s+/;
  $self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
  $self->{data_factor} = 1; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{
			name => 'Record_Type',
			bytes => '2'
		},
		{
			name => 'IMSI',
			bytes => '15'
		},
		{
			name => 'Dialled_Digits',
			bytes => '24'
		},
		{
			name => 'Service_Type',
			bytes => '2'
		},
		{
			name => 'Service_ID',
			bytes => '4'
		},
		{
			name => 'Originating_MSC_ID',
			bytes => '15'
		},
		{
			name => 'Originating_CELL_ID',
			bytes => '13'
		},
		{
			name => 'Station_Class_Mark',
			bytes => '1'
		},
		{
			name => 'Call_Start_Date',
			bytes => '6'
		},
		{
			name => 'Call_Start_Time',
			bytes => '6'
		},
		{
			name => 'Call_Duration',
			bytes => '6'
		},
		{
			name => 'Data_Volume',
			bytes => '12'
		},
		{
			name => 'Data_Volume_Reference',
			bytes => '6'
		},
		{
			name => 'Number_of_Pulses',
			bytes => '6'
		},
		{
			name => 'Call_End_Date',
			bytes => '6'
		},
		{
			name => 'Call_End_Time',
			bytes => '6'
		},
		{
			name => 'Filler',
			bytes => '4'
		},
		{
			name => 'Filler',
			bytes => '10'         # spec says 15 but file only has 10 this makes it work
		},
		{
			name => 'Filler',
			bytes => '13'
		},
		{
			name => 'PLMN_Code',
			bytes => '5'
		}
	];

	$self->{format} = $format;
}



1;
