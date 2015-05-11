package Ascertain::UM::VFI::Format::DS47;

use constant TRUE => 1;
use constant FALSE => undef;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);

sub init
{
	my $self = shift;

	$self->{type} = 'csv'; # csv fixedwidth asn1
	$self->{delimiter} = ';';
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
		{name => 'record_type'},
		{name => 'logging_time'},
		{name => 'submission_time'},
		{name => 'message_id'},
		{name => 'message_size'},
		{name => 'payer_msisdn'},
		{name => 'payer_imsi'},
		{name => 'originator_address'},
		{name => 'payer_prepaid_flag'},
		{name => 'recipient_address'},
		{name => 'roaming_information'},
		{name => 'result_code'},
		{name => 'origin_host'},
		{name => 'cost_unit'}
	];

	$self->{format} = $format;
}



1;
