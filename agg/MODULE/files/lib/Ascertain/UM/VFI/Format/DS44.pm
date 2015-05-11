package Ascertain::UM::VFI::Format::DS44;

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
	#$self->{skip_header_lines} = 1;
	#$self->{header_regex} = qr/^$/;
	$self->{trim_values} = TRUE;
	$self->{has_trailer} = FALSE;
	#$self->{trailer_regex} = qr/^$/;

	# don't validate the format_field_count against the number of fields in the input file
	# we only care about field 0 anyway
	$self->{lenient} = TRUE; 
  $self->{currency_factor} = 100; # if in euros then 100, if in cents then 1
  $self->{data_factor} = 1; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{name => 'subscriberType'},
		{name => 'field2'},
		{name => 'field3'},
		{name => 'field4'},
		{name => 'field5'},
		{name => 'field6'},
		{name => 'field7'},
		{name => 'field8'},
		{name => 'field9'},
		{name => 'revenue'},
		{name => 'field11'},
		{name => 'field12'},
		{name => 'field13'},
		{name => 'field14'},
		{name => 'startDateTime'},
	];

	$self->{format} = $format;
}

=top
		{name => 'field1'},
		{name => 'field2'},
		{name => 'field3'},
		{name => 'field4'},
		{name => 'field5'},
		{name => 'field6'},
		{name => 'field7'},
		{name => 'field8'},
		{name => 'field9'},
		{name => 'field10'},
		{name => 'field11'},
		{name => 'field12'},
		{name => 'field13'},
		{name => 'field14'},
		{name => 'field15'},
		{name => 'field16'},
		{name => 'field17'},
		{name => 'field18'},
		{name => 'field19'},
		{name => 'field20'},
		{name => 'field21'},
		{name => 'field22'},
		{name => 'field23'},
		{name => 'field24'},
		{name => 'field25'},
		{name => 'field26'},
		{name => 'field27'},
		{name => 'field28'},
		{name => 'field29'},
		{name => 'field30'},
		{name => 'field31'},
		{name => 'field32'},
		{name => 'field33'},
		{name => 'field34'},
		{name => 'field35'},
		{name => 'field36'},
		{name => 'field37'},
=cut

1;
