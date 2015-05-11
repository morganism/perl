package Ascertain::UM::VFI::Format::DS75;

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
  	$self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
  	$self->{data_factor} = 1024; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{name => 'RecordType'},
		{name => 'MMS_MessageId'},
		{name => 'Originator'},
		{name => 'Destination'},
		{name => 'MessageSize'},
		{name => 'SubmissionTime'},
		{name => 'FutureDeliveryDate'},
		{name => 'IncomingInterfaceID'},
		{name => 'OutgoingInterfaceID'},
		{name => 'MessageType'}
	];

	$self->{format} = $format;
}



1;
