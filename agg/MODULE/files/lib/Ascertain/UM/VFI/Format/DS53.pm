package Ascertain::UM::VFI::Format::DS53;

use constant TRUE => 1;
use constant FALSE => undef;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);


sub init
{
	my $self = shift;

	$self->{type} = 'csv'; # csv fixedwidth asn1
	$self->{delimiter} = ',';
	$self->{has_header} = TRUE;
	$self->{skip_header_lines} = 1;
	$self->{trim_values} = TRUE;
	$self->{has_trailer} = FALSE;
  $self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
  $self->{data_factor} = 1048576; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{name => 'SUBSCRIBER_TYPE'},
		{name => 'SERVICE_ID'},
		{name => 'SERVED_MSISDN'},
		{name => 'CHARGING_ID'},
		{name => 'GGSN_ADDRESS'},
		{name => 'SERVED_IMSI'},
		{name => 'SGSN_ADDRESS'},
		{name => 'ACCESS_POINT_NAME'},
		{name => 'PDP_ADDRESS'},
		{name => 'SESSION_ID'},
		{name => 'TOTAL_VOLUME'},
		{name => 'RECORD_START_TIME_FORMATTED'},
		{name => 'RECORD_END_TIME_FORMATTED'},
		{name => 'UPLINK_VOLUME'},
		{name => 'DOWNLINK_VOLUME'},
		{name => 'CCN_SESSION_ID'},
		{name => 'CCN_SERVICE_ID'},
		{name => 'SERVED_IMEI'},
		{name => 'FINAL_RECORD_INDICATOR'},
		{name => 'ACCIDENTAL_USAGE_INDICATOR'},
		{name => 'RECORD_SEQ_NUMBER'},
		{name => 'SESSION_DURATION'},
		{name => 'SESSION_START_TIME_FORMATTED'},
		{name => 'SESSION_END_TIME_FORMATTED'},
		{name => 'AGGREGATED_COUNTER'},
		{name => 'CALL_SERVICE_TYPE'},
		{name => 'CALL_SERVICE_CODE'},
		{name => 'PLMN_CODE'},
		{name => 'ERROR_CODE'},
		{name => 'ERROR_REASON'},
		{name => '3GPP_RAT_TYPE'}
	];

	$self->{format} = $format;
}



1;
