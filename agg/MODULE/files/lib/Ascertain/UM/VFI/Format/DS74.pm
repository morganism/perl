package Ascertain::UM::VFI::Format::DS74;

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
	$self->{has_trailer} = TRUE;
	$self->{trailer_regex} = qr/^TRA/;
	$self->{trim_values} = TRUE;
	$self->{lenient} = TRUE;
  	$self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
  	$self->{data_factor} = 1; # if in MB then 1048576, if in bytes then 1

	my $format = 
	[
		{
			name => 'BlockCode1',
			bytes => 4 
		},
		{
			name => 'BlockLength1',
			bytes => 3
		},
		{
			name => 'RecordVersion',
			bytes => 4
		},
		{
			name => 'StartDateTime',
			bytes => 14
		},
		{
			name => 'Duration',
			bytes => 9
		},
		{
			name => 'CallType',
			bytes => 1
		},
		{
			name => 'Switch',
			bytes => 9 
		},
		{
			name => 'InGroup',
			bytes => 9
		},
		{
			name => 'OutGroup',
			bytes => 9
		},
		{
			name => 'Service',
			bytes => 9 
		},
		{
			name => 'BlockCode2',
			bytes => 4
		},
		{
			name => 'BlockLength2',
			bytes => 3
		},
		{
			name => 'CallingPartyNumber',
			bytes => 20
		},
		{
                        name => 'BlockCode3',
                        bytes => 4
                },
                {
                        name => 'BlockLength3',
                        bytes => 3
                },
		{
			name => 'CalledPartyNumber',
			bytes => 20
		},
		{
                        name => 'BlockCode4',
                        bytes => 4
                },
                {
                        name => 'BlockLength4',
                        bytes => 3
                },
		{
			name => 'RecordSeqNum',
			bytes => 8
		},
		{
                        name => 'BlockCode5',
                        bytes => 4
                },
                {
                        name => 'BlockLength5',
                        bytes => 3
                },
		{
			name => 'CallEndTime',
			bytes => 6
		},
		{
                        name => 'BlockCode6',
                        bytes => 4
                },
                {
                        name => 'BlockLength6',
                        bytes => 3
                },
		{
			name => 'LastBlock',
			bytes => 20
		}
	];

	$self->{format} = $format;
}



1;
