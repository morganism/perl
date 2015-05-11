package Ascertain::UM::VFI::Format::DS6;

use constant TRUE => 1;
use constant FALSE => undef;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);


sub init
{
	my $self = shift;

	$self->{type} = 'csv';
	$self->{delimiter} = '%';
	$self->{trim_values} = TRUE;

	$self->{has_trailer} = TRUE;
	$self->{trailer_regex} = qr/^Number of Records wrote is*/;

	$self->{has_header} = FALSE;
  $self->{currency_factor} = 100; # if in euros then 100, if in cents then 1
  $self->{data_factor} = 1048576; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{name => 'RECORD_NUMBER'},
		{name => 'DAILY_SUBSCRIBER'},
		{name => 'DAILY_START_DATE'},
		{name => 'DAILY_START_TIME'},
		{name => 'CALL_END_DATE'},
		{name => 'CALL_END_TIME'},
		{name => 'CALL_DIALLED_DIGITS'},
		{name => 'CALL_DURATION'},
		{name => 'CALL_DIRECTION'},
		{name => 'CALL_CLASS'},
		{name => 'CALL_ZONE'},
		{name => 'CALL_UNITS'},
		{name => 'CALL_CATEGORY'},
		{name => 'CALL_BREAKDOWN_CODE'},
		{name => 'CALL_REASON_CODE'},
		{name => 'CALL_COST_PRICE'},
		{name => 'CALL_RETAIL_PRICE'},
		{name => 'CALL_TAX'},
		{name => 'CALL_DISCOUNT'},
		{name => 'CALL_PP_ALLOWANCE'},
		{name => 'CALL_INTERNATIONAL'},
		{name => 'CALL_ERROR_CODE'},
		{name => 'CALL_BILLED_FLAG'},
		{name => 'CALL_HIDDEN_LENGTH'},
		{name => 'CALL_HIDDEN_START'},
		{name => 'CALL_RECORD_TYPE'},
		{name => 'CALL_TYPE'},
		{name => 'CALL_PLMN_CODE'},
		{name => 'CALL_IMSI'},
		{name => 'CALL_MSC_ID'},
		{name => 'CALL_LOCATION'},
		{name => 'CALL_MS_CLASS_MK'},
		{name => 'CALL_DATA_VOL'},
		{name => 'CALL_DATA_VOL_REF'},
		{name => 'CALL_SERVICE_TYPE'},
		{name => 'CALL_SERVICE_CODE'},
		{name => 'CALL_SERVICE_MOD'},
		{name => 'CALL_DESTINATION'},
		{name => 'CALL_TAP_IND'},
		{name => 'CALL_TERM_MSC_ID'},
		{name => 'CALL_TERM_LOCATION'},
		{name => 'CALL_ORIGINATION'},
		{name => 'SPECIALIST_SYSTEM'},
		{name => 'LAST_FIELD'}
	];

	$self->{format} = $format;
}



1;
