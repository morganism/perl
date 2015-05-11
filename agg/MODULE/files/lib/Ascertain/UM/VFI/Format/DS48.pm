package Ascertain::UM::VFI::Format::DS48;

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
	$self->{has_header} = TRUE;
	$self->{skip_header_lines} = 1;
	$self->{header_regex} = qr/^filename/;
	$self->{trim_values} = TRUE;
	$self->{has_trailer} = FALSE;
	#$self->{trailer_regex} = qr/^$/;
	$self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
	$self->{data_factor} = 1048576; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{name => 'filename'},
		{name => 'ADDRESS_HIDING_STATUS_'},
		{name => 'APPLICATION_ID'},
		{name => 'BATCH_END_TIME_'},
		{name => 'BATCH_SEQ_NUMBER'},
		{name => 'BATCH_START_TIME'},
		{name => 'BIT_MASK'},
		{name => 'BLOCK_SEQ_NUMBER'},
		{name => 'CHARGED_PARTY'},
		{name => 'CHARGED_PARTY_ID'},
		{name => 'CHECK_SUM'},
		{name => 'CNT_NUMBER_AUDIO'},
		{name => 'CNT_NUMBER_IMAGE'},
		{name => 'CNT_NUMBER_OTHER'},
		{name => 'CNT_NUMBER_TEXT'},
		{name => 'CNT_NUMBER_VIDEO'},
		{name => 'CNT_SIZE_AUDIO'},
		{name => 'CNT_SIZE_IMAGE'},
		{name => 'CNT_SIZE_OTHER'},
		{name => 'CNT_SIZE_TEXT'},
		{name => 'CNT_SIZE_VIDEO'},
		{name => 'CONTENT_ADAPTATION'},
		{name => 'DADDR'},
		{name => 'DATA_LENGTH_IN_BLOCK'},
		{name => 'DELIVERY_REPORT'},
		{name => 'DELIVERY_STATUS'},
		{name => 'DESIRED_DELIVERY_TIME'},
		{name => 'DEST_IMSI'},
		{name => 'DEST_MMSC'},
		{name => 'DEST_MSC'},
		{name => 'DEST_VASP_ID'},
		{name => 'DEST_VAS_ID'},
		{name => 'DIWTYPE'},
		{name => 'DRM_INDICATION'},
		{name => 'ERROR_CAUSE'},
		{name => 'EXCHANGE_ID'},
		{name => 'EXCHANGE_ID_'},
		{name => 'FIRST_RECORD_NUMBER'},
		{name => 'FORMAT_VERSION'},
		{name => 'FORMAT_VERSION_FILLER'},
		{name => 'FORWARDED_BY'},
		{name => 'HEADER_RECORD_LENGTH'},
		{name => 'HEADER_RECORD_TYPE'},
		{name => 'INCOMING_TIME_DATE'},
		{name => 'LAST_RECORD__NUMBER_'},
		{name => 'LENGTH'},
		{name => 'LOGGINGTIME'},
		{name => 'MESSAGE_CLASS'},
		{name => 'MESSAGE_SIZE'},
		{name => 'MSG_ID'},
		{name => 'MSG_LEN'},
		{name => 'NODE_ID'},
		{name => 'OADDR'},
		{name => 'OIWTYPE'},
		{name => 'ORIGINAL_MESSAGE_ID'},
		{name => 'ORIG_IMSI'},
		{name => 'ORIG_MMSC'},
		{name => 'ORIG_MSC'},
		{name => 'ORIG_VASP_ID'},
		{name => 'ORIG_VAS_ID'},
		{name => 'PRIORITY'},
		{name => 'PRODUCT_CODE'},
		{name => 'READ_REPLY'},
		{name => 'RECIPIENT_CHARGING_TYPE'},
		{name => 'RECIPIENT_NUMBER'},
		{name => 'RECIPIENT_PREPAID_STATUS'},
		{name => 'RECIPIENT_TERMINAL_IP_ADDRESS'},
		{name => 'RECIPIENT_TERMINAL_TYPE'},
		{name => 'SENDER_CHARGING_TYPE'},
		{name => 'SENDER_PREPAID_STATUS'},
		{name => 'SENDER_TERMINAL_IP_ADDRESS'},
		{name => 'SENDER_TERMINAL_TYPE'},
		{name => 'SERVICE_CODE'},
		{name => 'SERVICE_TYPE'},
		{name => 'SPARE'},
		{name => 'STATUS_EXTENSION'},
		{name => 'SUCCESS_INDICATOR'},
		{name => 'TARIFF_CLASS'},
		{name => 'TRAILER_RECORD_LENGTH'},
		{name => 'TRAILER_RECORD_TYPE_'},
		{name => 'TYPE_'},
		{name => 'TYPE_BLOCK_TYPE'}
	];

	$self->{format} = $format;
}



1;
