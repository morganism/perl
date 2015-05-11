package Ascertain::UM::VFI::Aggregator::DS86;

#------------------------------------------------------------------------------
# This is for contructing this as a subclass of Aggregator
#------------------------------------------------------------------------------
use Data::Dumper;

use vars qw(@ISA);
our @ISA = qw(Ascertain::UM::VFI::Aggregator);
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# This is the DS specific 'aggregate' method called by Aggregator->aggregate()
#------------------------------------------------------------------------------

use constant TRUE => 1;
use constant FALSE => undef;
use constant UNKNOWN => "UNKNOWN";


sub _aggregate
{
	my $self = shift;
	my $args = shift;

	my $d = $args->{record};

  #-- reset the indicators
  #-- the parent class Aggregator.pm defines available AUTOLOADed terms
  $self->resetAttributes();

  #-- set the vars used as keys and counters when aggregating
  #-- the parent class Aggregator.pm defines available AUTOLOADed terms
	$self->D_TIMESLOT("1999011401");          #AGGREGATOR KEY
	$self->D_USAGE_TYPE(UNKNOWN);        #AGGREGATOR KEY
	$self->D_SERVICE_TYPE("DATA");      #AGGREGATOR KEY
  #--- EVERYTHING ABOVE IS REQUIRED

	my $ST_ALL = FALSE;
	my $ST_DATA = FALSE;
	my $ST_DATA_GPRS = FALSE;
	my $ST_DATA_GPRS_POSTPAID = FALSE;
	my $ST_DATA_GPRS_OUTBOUND_ROAMERS = FALSE;
	my $ST_DATA_STRIP = FALSE;
	my $ST_DATA_GPRS_OUTBOUND_ROAMERS_STRIP = FALSE;


	my @serviceTypes; # each time a service type tests TRUE push it
	$ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

	$self->D_USAGE_TYPE("DATA");        #AGGREGATOR KEY

	# ---- TIMESLOT
	#101217115346
	my $startDateTime = (defined $d->{CALL_START_DATETIME}) ? $d->{CALL_START_DATETIME} : "";
	my $timeSlot = "20" . $startDateTime;
	$timeSlot =~ s/^(\d{10}).*/$1/;
	unless ($timeSlot =~ m/\d{10}/)
	{
		die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
	}

	$self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
	# ---- TIMESLOT

	my $duration = (defined $d->{CALL_DURATION}) ? $d->{CALL_DURATION} : 0;

	my $oInputFile = $self->getInputFileObject(); # need this to check filename
	my $edrFilename = $oInputFile->getEdrFileName();

	# --- start the business rules here
	if ($edrFilename =~ /\.strip/) 
	{
		$ST_DATA_STRIP = TRUE; push @serviceTypes, "ST_DATA_STRIP";

		if (defined $d->{PLMN_CODE} and $d->{PLMN_CODE} ne "IRLVF")
		{
			$ST_DATA_GPRS_OUTBOUND_ROAMERS_STRIP = TRUE; push @serviceTypes, "ST_DATA_GPRS_OUTBOUND_ROAMERS_STRIP";
		}
	}
	else
	{
		$ST_DATA = TRUE; push @serviceTypes, "ST_DATA";
		$ST_DATA_GPRS = TRUE; push @serviceTypes, "ST_DATA_GPRS";
		$ST_DATA_GPRS_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_GPRS_POSTPAID";

		if (defined $d->{PLMN_CODE} and $d->{PLMN_CODE} ne "IRLVF")
		{
			$ST_DATA_GPRS_OUTBOUND_ROAMERS = TRUE; push @serviceTypes, "ST_DATA_GPRS_OUTBOUND_ROAMERS";
		}
	}

	my $sum_duration = (defined $d->{CALL_DURATION}) ? $d->{CALL_DURATION} : "0";
	my $sum_bytes = (defined $d->{DATA_VOLUME}) ? $d->{DATA_VOLUME} : "0";
	my $sum_value = (defined $d->{CALL_RETAIL_PRICE}) ? $d->{CALL_RETAIL_PRICE} : "0";

	#--- EVERYTHING BELOW IS REQUIRED
	# ---- FILL AGGREGATION DATA STRUCTURE
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => $sum_duration,
			sum_bytes    => $sum_bytes,
			sum_value    => $sum_value
		}
	); # call the method in the parent class
	# ---- FILL AGGREGATION DATA STRUCTURE

}
#------------------------------------------------------------------------------



1;
