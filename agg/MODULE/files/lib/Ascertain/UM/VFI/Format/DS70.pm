package Ascertain::UM::VFI::Format::DS70;

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
        $self->{decoder} = 'PGW_decoder -' ;

	my $format = 
	[
		{name => 'recordType'},
                {
			name => 'servedIMSI',
			decode => 'decodeIMSI'
		},
                {name => 'iPBinV4Address'},
                {name => 'chargingID'},
                {name => 'iPBinV4Address'},
                {name => 'accessPointNameNI'},
                {
			name => 'pdpPDNType',
			decode => 'decodeDigitPairs'
		},
                {name => 'dynamicAddressFlag'},
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
                {
			name => 'servedMSISDN',
			decode => 'decodeDigitPairs'
		},
                {name => 'chargingCharacteristics'},
                {name => 'chChSelectionMode'},
                {	
			name => 'servingNodePLMNIdentifier',
			decode => 'decodeDigitPairs'
		},
                {name => 'rATType'},
                {name => 'mSTimeZone'},
                {name => 'userLocationInformation'},
                {name => 'ratingGroup'},
                {name => 'chargingRuleBaseName'},
                {name => 'resultCode'},
                {
			name => 'timeOfFirstUsage',
			decode => 'decodeTimeslot'
		},
                {
			name => 'timeOfLastUsage',
			decode => 'decodeTimeslot'
		},
                {name => 'timeUsage'},
                {name => 'qCI'},
                {name => 'maxRequestedBandwithUL'},
                {name => 'maxRequestedBandwithDL'},
                {name => 'guaranteedBitrateUL'},
                {name => 'guaranteedBitrateDL'},
                {name => 'aRP'},
                {name => 'datavolumeFBCUplink'},
                {name => 'datavolumeFBCDownlink'},
                {
			name => 'timeOfReport',
			decode => 'decodeTimeslot'
		},
                {
			name => 'userLocationInformation',
			decode => 'decodeDigitPairs'
		},
                {name => 'servingNodeType'},
                {name => 'subscriptionIDType'},
                {name => 'subscriptionIDData'},
                {
			name => 'p-GWPLMNIdentifier',
			decode => 'decodeDigitPairs'
		},
                {name => 'pDNConnectionID'},
		{
                        name => 'startTime',
                        decode => 'decodeTimeslot'
                },
		{
                        name => 'stopTime',
                        decode => 'decodeTimeslot'
                }
	];

	$self->{format} = $format;
}

1;
