package Ascertain::UM::VFI::Aggregator::DS54;

#------------------------------------------------------------------------------
# This is for contructing this as a subclass of Aggregator
#------------------------------------------------------------------------------
use Data::Dumper;
use Time::Local;

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
  my $ST_DATA_2G = FALSE;
  my $ST_DATA_3G = FALSE;
  my $ST_DATA_4G = FALSE;
  my $ST_DATA_2G_PREPAID = FALSE;
  my $ST_DATA_2G_POSTPAID = FALSE;
  my $ST_DATA_3G_PREPAID = FALSE;
  my $ST_DATA_3G_POSTPAID = FALSE;
  my $ST_DATA_4G_PREPAID = FALSE;
  my $ST_DATA_4G_POSTPAID = FALSE;
  my $ST_UNIDENT = TRUE;

  my @serviceTypes; # each time a service type tests TRUE push it
  $ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

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
  

  if (defined $d->{RadioAccessTechnology} and $d->{RadioAccessTechnology} eq "1" ) # UTRAN / 3G
  {
     $ST_DATA_3G = TRUE; push @serviceTypes, "ST_DATA_3G";

     if ($POSTPAID_FLAG) 
     {
   	$ST_DATA_3G_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_3G_POSTPAID"; 
     }
     elsif ($PREPAID_FLAG)
     {
	$ST_DATA_3G_PREPAID = TRUE; push @serviceTypes, "ST_DATA_3G_PREPAID";
     }
  }
  elsif (defined $d->{RadioAccessTechnology} and $d->{RadioAccessTechnology} eq "2" ) # GERAN / 2G
  {
     $ST_DATA_2G = TRUE; push @serviceTypes, "ST_DATA_2G";
     
     if ($POSTPAID_FLAG)
     {
        $ST_DATA_2G_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_2G_POSTPAID";
     }
     elsif ($PREPAID_FLAG)
     {
        $ST_DATA_2G_PREPAID = TRUE; push @serviceTypes, "ST_DATA_2G_PREPAID";
     }

  }
  elsif (defined $d->{RadioAccessTechnology} and $d->{RadioAccessTechnology} eq "6" ) # EUTRAN / 4G
  {
     $ST_DATA_4G = TRUE; push @serviceTypes, "ST_DATA_4G";
     
     if ($POSTPAID_FLAG)
     {
        $ST_DATA_4G_POSTPAID = TRUE; push @serviceTypes, "ST_DATA_4G_POSTPAID";
     }
     elsif ($PREPAID_FLAG)
     {
        $ST_DATA_4G_PREPAID = TRUE; push @serviceTypes, "ST_DATA_4G_PREPAID";
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

  my($duration)=0;
  if ( defined $d->{StartRecordTimeChar} and defined $d->{StopRecordTimeChar} ) {
	
 	$duration =  
		timegm(reverse(unpack("A4 A2 A2 A2 A2 A2",($d->{StopRecordTimeChar}  - 100000000))))
		- timegm(reverse(unpack("A4 A2 A2 A2 A2 A2",($d->{StartRecordTimeChar} - 100000000))))
	; 
	#if ($duration < 0) { $duration = 0}
  }	
  my $volume = (defined $d->{TotalUSU}) ? $d->{TotalUSU} : 0;


  #--- EVERYTHING BELOW IS REQUIRED
  # ---- FILL AGGREGATION DATA STRUCTURE
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => $duration,
			sum_bytes    => $volume,
			sum_value    => 0
		}
	); # call the method in the parent class
  # ---- FILL AGGREGATION DATA STRUCTURE
}
#------------------------------------------------------------------------------



1;
