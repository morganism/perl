#-----------------------------------------------------------------------------
# script   : StopWatch
# author   : Cartesian Limited
# author   : morgan.sziraki@cartesian.co.uk
# date     : Fri May  8 16:00:05 BST 2009
# $Revision: 1.0 
#          : For BASE, using the data from bil_cdr* 
#          : produce UCDR output 
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# StopWatch
#  start
#  stop
#  getElapsedTime
#  getLabel
#-----------------------------------------------------------------------------
package StopWatch;
use Time::HiRes qw( gettimeofday tv_interval );

use constant SW_FULL     => "FULL";
use constant SW_DATETIME => "DATETIME";
use constant SW_DATE     => "DATE";
use constant SW_INTERVAL => "INTERVAL";

sub new
{
	my $class = shift;
	my $label = shift;

	my $self = {};
	$self->{label} = $label;
	bless ($self, $class);
	$self->start(); 
	return $self;
}

sub start
{
	my $self = shift;
	$self->{startTime} = [gettimeofday()];	
}

sub stop
{
	my $self = shift;
	$self->{stopTime} = [gettimeofday()];	
}

sub getElapsedTime
{
	my $self = shift;
	return tv_interval($self->{startTime}, $self->{stopTime})
}

sub getLabel
{
	my $self = shift;
	return $self->{label};
}

#-----------------------------------------------------------------------------
# stamp()
# return a timestamp YYYYMMDD HH24MISS.FF
#-----------------------------------------------------------------------------
sub stamp
{
	my $self = shift;
	my $arg = shift;
	my $format = defined($arg) ? $arg : SW_FULL;
	my ($epoch, $usec) = gettimeofday();
	my ($sec, $min, $hour, $dom, $mon, $year, $dow, $doy, $dst) 
		= localtime($epoch);
	$year += 1900;
	$mon  += 1;
	my $stamp ;

	if ($format eq SW_FULL)
	{
		$stamp	= sprintf "%4d%02d%02d %02d%02d%02d.%06d",
				 $year,$mon,$dom,$hour,$min,$sec,$usec;
	}
	elsif ($format eq SW_DATETIME)
	{
		$stamp	= sprintf "%4d%02d%02d%02d%02d%02d",
				 $year,$mon,$dom,$hour,$min,$sec;
	}
	elsif ($format eq SW_DATE)
	{
		$stamp	= sprintf "%4d%02d%02d",
				 $year,$mon,$dom;
	}
	elsif ($format eq SW_INTERVAL)
	{
		$stamp = [gettimeofday()];
	}
	else
	{
		die "StopWatch: Illegal State, unsupported format: [$format]\n";
	}

	return $stamp;
}

# convert seconds to formatted, human read hours, minutes, and seconds
sub hms
{
	my $self = shift;
  my $s = shift;
  my $h = int($s / 3600);
  $s -= (3600 * $h);
  my $m = int($s / 60);
  $s -= (60 * $m);
  return sprintf "%02dh %02dm %fs", $h, $m, $s;
}
1;
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# DOCUMENTATION
#-----------------------------------------------------------------------------

=head1 NAME

StopWatch - Some short description


=head1 SYNOPSIS

B<StopWatch> [OPTION] ...

=head1 DESCRIPTION

Place a desription of this here.

=head2 OPTIONS        

Should include options and parameters.


B<-h, --help>
        display some help and usage.

B<-v, --version>
        display version information.


=head1 USAGE

Usage information goes here.


=head1 EXAMPLES

Place examples here.

=head1 RETURN VALUES  

Sections two and three function calls.

=head1 ENVIRONMENT    

Describe environment variables.

=head1 FILES          

Files associated with the subject.

=head1 DIAGNOSTICS    

Normally used for section 4 device interface diagnostics.

=head1 ERRORS         

Sections two and three error and signal handling.

=head1 SEE ALSO       

Cross references and citations.

=head1 STANDARDS      

Conformance to standards if applicable.

=head1 BUGS           

Gotchas and caveats.

=head1 SECURITY CONSIDERATIONS

=head1 COPYRIGHT

Copyright 2009, Cartesian Limited

=cut

