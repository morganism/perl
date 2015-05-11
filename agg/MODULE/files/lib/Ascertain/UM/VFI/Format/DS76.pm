package Ascertain::UM::VFI::Format::DS76;

use constant TRUE => 1;
use constant FALSE => undef;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);


#--- !!!!!!!!!!!! Just a hust to be replaced

sub init
{
	my $self = shift;

	$self->{type} = 'csv'; # csv fixedwidth asn1
	$self->{delimiter} = ',';
	$self->{has_header} = FALSE;
	$self->{trim_values} = TRUE;
	$self->{has_trailer} = FALSE;
  	$self->{currency_factor} = 100; # if in euros then 100, if in cents then 1
  	$self->{data_factor} = 1048576; # if in MB then 1048576, if in bytes then 1
					# ( bytes for GPRS and KB for MMS )

	my $format = 
	[
		{name => 'A_NUMBER'},
		{name => 'B_NUMBER'},
		{name => 'START_DATE'},
		{name => 'START_TIME'},
		{name => 'TRAFFIC_TYPE'},
		{name => 'TIER_ID'},
		{name => 'CALL_DESTINATION'},
		{name => 'ROUTE_IN'},
		{name => 'ROUTE_OUT'},
		{name => 'DURATION'},
		{name => 'VOLUME'},
		{name => 'MSCID'},
		{name => 'OLO_IDENTIFIER'},
		{name => 'BEARER_SERVICE_CODE'},
		{name => 'END_DATE_TIME'},
		{name => 'RECORD_TYPE'},
		{name => 'CHARGE'}
	];

	$self->{format} = $format;
}



1;
