package Ascertain::UM::VFI::Aggregator::DS78;

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

    $self->D_USAGE_TYPE("VOICE");        #AGGREGATOR KEY


    my $ST_ALL = FALSE;
    my $ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MO = FALSE;
    my $ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MT = FALSE;
    my $ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MVNO = FALSE;
    my $ST_UNIDENT = TRUE;

    my @serviceTypes; # each time a service type tests TRUE push it
    $ST_ALL = TRUE; push @serviceTypes, "ST_ALL";

    if (defined $d->{record_type} and defined $d->{imsi})
    {

       if ($d->{imsi} =~ /^272011/) { # MVNO
          $ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MVNO = TRUE; push @serviceTypes, "ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MVNO";
          $ST_UNIDENT = FALSE;
       }

       if ($d->{record_type} eq "30" and $d->{imsi} =~ /^27201[^1]/)
       {
          $ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MT = TRUE; push @serviceTypes, "ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MT";
          $ST_UNIDENT = FALSE;
       }
  	   # not expecting any MO records, but adding just in case
       elsif ($d->{record_type} eq "20" and $d->{imsi} =~ /^27201[^1]/)
       {
          $ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MO = TRUE; push @serviceTypes, "ST_VOICE_OUTBOUND_POSTPAID_ROAMERS_MO";
          $ST_UNIDENT = FALSE;
       }
    }

    #2010-12-17 11:53:46
    my $startDateTime = $d->{call_start_date} . $d->{call_start_time};
    my $timeSlot = "20" . $startDateTime;
    $timeSlot =~ s/^(\d{10}).*/$1/;
    unless ($timeSlot =~ m/\d{10}/)
    {
        die("ERROR:TIMESLOT - Invalid timeslot detected, parse error ? [$timeSlot]");
    }

    $self->D_TIMESLOT($timeSlot); #AGGREGATOR KEY
    # ---- TIMESLOT

    my $duration = (defined $d->{call_duration}) ? $d->{call_duration} : 0;
    my $data_volume = (defined $d->{data_volume}) ? $d->{data_volume} : 0;


	#--- EVERYTHING BELOW IS REQUIRED
	# ---- FILL AGGREGATION DATA STRUCTURE
	push @serviceTypes, "ST_UNIDENT" if ($ST_UNIDENT);
	$self->{service_types} = \@serviceTypes; # store this in object
	$self->process
	(
		{
			event_count  => 1,
			sum_duration => $duration,
			sum_bytes    => $data_volume,
			sum_value    => 0
		}
	); # call the method in the parent class
	# ---- FILL AGGREGATION DATA STRUCTURE

}
#------------------------------------------------------------------------------



1;
