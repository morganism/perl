package Ascertain::UM::VFI::Aggregator::DS54;

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
  $self->D_SERVICE_TYPE(UNKNOWN);      #AGGREGATOR KEY
  #--- EVERYTHING ABOVE IS REQUIRED

  my $ST_DATA_GPRS = FALSE;
  my $ST_DATA_WAP = FALSE;
  my $ST_DATA_GPRS_PREPAID = FALSE;
  my $ST_DATA_GPRS_POSTPAID = FALSE;
  my $ST_DATA_WAP_PREPAID = FALSE;
  my $ST_DATA_WAP_POSTPAID = FALSE;
  my $ST_UNIDENT = TRUE;

  my @serviceTypes; # each time a service type tests TRUE push it
  $ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

#ST_DATA_GPRS
#ST_DATA_WAP
#ST_DATA_GPRS_PREPAID
#ST_DATA_GPRS_POSTPAID
#ST_DATA_WAP_PREPAID
#ST_DATA_WAP_POSTPAID

  $self->D_USAGE_TYPE("DATA");        #AGGREGATOR KEY

  # set flags for reuse of rules
  $GPRS_FLAG = FALSE;
  $WAP_FLAG = FALSE;
  $PREPAID_FLAG = FALSE;
  $POSTPAID_FLAG = FALSE;
  if (defined $d->{subscriberType} and $d->{subscriberType} eq "prepaid")
  {
    $PREPAID_FLAG = TRUE;
  }
  elsif (defined $d->{subscriberType} and $d->{subscriberType} eq "postpaid")
  {
    $POSTPAID_FLAG = TRUE;
  }
  else
  {
    push @serviceTypes, "ST_UNIDENT";
  }

  if (defined $d->{CalledStationId} and $d->{CalledStationId} !~ /live.vodafone.com|wap.vodafone.ie/)
  {
    $GPRS_FLAG = TRUE;
    $ST_DATA_GPRS = TRUE; push @serviceTypes, "ST_DATA_GPRS";
  }
  else
  {
    $ST_DATA_WAP = TRUE; push @serviceTypes, "ST_DATA_WAP";
    if (defined $d->{RatingGroup} and $d->{RatingGroup} ne "1499")
    {
      $WAP_FLAG = TRUE;
    }
  }

  if ($PREPAID_FLAG)
  {
    if ($GPRS_FLAG)
    {
      $ST_DATA_GPRS_PREPAID = TRUE; push @serviceTypes, "ST_DATA_GPRS_PREPAID";
    }
    elsif ($WAP_FLAG)
    {
      $ST_DATA_WAP_PREPAID = TRUE; push @serviceTypes, "ST_DATA_WAP_PREPAID";
    }
  }
  elsif ($POSTPAID_FLAG)
  {
    if ($GPRS_FLAG)
    {
      $ST_DATA_GPRS_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_GPRS_POSTPAID";
    }
    elsif ($WAP_FLAG)
    {
      $ST_DATA_WAP_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_WAP_POSTPAID";
    }
  }
  


  # ---- TIMESLOT
  #20101209133516
  my $startDateTime = (defined $d->{StartRecordTimeChar}) ? $d->{StartRecordTimeChar} : "";
  $startDateTime =~ s/^(\d{10}).*/$1/g;
  my $timeSlot = $startDateTime;
  unless ($timeSlot =~ m/\d{10}/)
  {
    die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
  }

  $self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
  # ---- TIMESLOT



  my $volume = (defined $d->{TotalUSU}) ? $d->{TotalUSU} : 0;


  #--- EVERYTHING BELOW IS REQUIRED
  # ---- FILL AGGREGATION DATA STRUCTURE
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => 0,
			sum_bytes    => $volume,
			sum_value    => 0
		}
	); # call the method in the parent class
  # ---- FILL AGGREGATION DATA STRUCTURE
}
#------------------------------------------------------------------------------



1;
