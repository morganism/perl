package Ascertain::UM::VFI::Format::DS72;

use constant TRUE => 1;
use constant FALSE => undef;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Format);

sub init
{
	my $self = shift;

	$self->{type} = 'asn1'; # csv fixedwidth asn1
	#$self->{has_header} = TRUE;
	#$self->{skip_header_lines} = 1;
	#$self->{header_regex} = qr/^$/;
	$self->{trim_values} = TRUE;
	#$self->{has_trailer} = TRUE;
	#$self->{trailer_regex} = qr/^$/;
	$self->{currency_factor} = 1; # if in euros then 100, if in cents then 1
	$self->{data_factor} = 1048576; # if in MB then 1048576, if in bytes then 1
        $self->{decoder} = 'SGSN_decoder -' ;

	my $format = 
	[
	        {name => 'recordType'},
                {
			name => 'servedIMEI',
			decode => 'decodeIMSI'
		},
		{
			name => 'servedIMSI',
			decode => 'decodeIMSI'
		},
                {name => 'iPBinV4Address'},
                {name => 'msNetworkCapability'},
                {name => 'routingArea'},
                {
			name => 'locationAreaCode',
			decode => 'decodeHexPairs'
		},
                {
			name => 'cellIdentifier',
			decode => 'decodeHexPairs'
		},
                {name => 'chargingID'},
		{name => 'accessPointNameNI'},
                {
			name => 'pdpType',
			decode => 'decodeDigitPairs'
		},
                {
			name => 'qosRequested',
			decode => 'decodeDigitPairs'
		},
                {
			name => 'qosNegotiated',
			decode => 'decodeDigitPairs'
		},
                {name => 'dataVolumeGPRSUplink'},
                {name => 'dataVolumeGPRSDownlink'},
                {name => 'changeCondition'},
                {
			name => 'changeTime',
			decode => 'decodeTimeslot'
		},
                {
			name => 'recordOpeningTime',
			decode => 'decodeTimeslot'
		},
                {name => 'duration'},
                {name => 'causeForRecClosing'},
                {name => 'recordSequenceNumber'},
                {name => 'nodeID'},
                {name => 'localSequenceNumber'},
                {name => 'apnSelectionMode'},
		{name => 'accessPointNameOI'},
                {
			name => 'servedMSISDN',
			decode => 'decodeDigitPairs'
		},
                {name => 'chargingCharacteristics'},
                {name => 'chChSelectionMode'},
                {name => 'dynamicAddressFlag'}
	];

	$self->{format} = $format;
}

1;
