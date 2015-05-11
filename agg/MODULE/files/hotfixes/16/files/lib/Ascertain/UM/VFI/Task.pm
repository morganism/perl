package Task;

use Data::Dumper;
use FileHandle;

use constant TRUE => 1;
use constant FALSE => undef;
use constant UNKNOWN => "UNKNOWN";


sub new
{
	my $proto = shift;
	my $class = ref $proto || $proto;
	my $self = {};
	my $args = shift;
	$self->{task_filename} = $args->{task_filename};
	$self->{datasource} = $args->{datasource};
	$self->{input_files} = $args->{input_files};
	$self->{service_types} = $args->{service_types};
	$self->{start_timeslot} =  $args->{start_timeslot};
	$self->{end_timeslot} =  $args->{end_timeslot};
	$self->{output_file} =  $args->{output_file};
	$self->{task_writer_job_logfile} =  $args->{task_writer_job_logfile};
	$self->{task_writer_logfile} =  $args->{task_writer_logfile};
	$self->{max_records} =  $args->{max_records};
	$self->{logger} = $args->{logger};
	$self->{debugger} = $args->{debugger};
	$self->{fh} = new FileHandle(">$self->{output_file}") if (defined $self->{output_file});

	bless $self, $class;
	return $self;
}

sub getMaxRecords
{
	my $self = shift;
	return $self->{max_records};
}

sub getTaskFilename
{
	my $self = shift;
	return $self->{task_filename};
}

sub setTaskFilename
{
	my $self = shift;
	my $name = shift;
	$self->{task_filename} = $name;
}

sub getDataSource
{
	my $self = shift;
	return $self->{datasource};
}

sub getInputFiles
{
	my $self = shift;
	return @{$self->{input_files}};
}

sub getServiceTypes
{
	my $self = shift;
	return @{$self->{service_types}};
}

sub getStartTimeslot
{
	my $self = shift;
	return $self->{start_timeslot};
}

sub getEndTimeslot
{
	my $self = shift;
	return $self->{end_timeslot};
}

sub getOutputFilename
{
	my $self = shift;
	return $self->{output_file};
}

sub getTaskWriterJobLogFile
{
	my $self = shift;
	return $self->{task_writer_job_logfile}; # this is the job log file for the Event Viewer job
}

sub getLogFileForAggregatorToUse
{
	my $self = shift;
	return $self->{task_writer_logfile}; # tell the aggregator what logfile to write to
}

sub setOutputFilename
{
	my $self = shift;
	$self->{output_file} = shift;
	$self->{fh} = new FileHandle(">$self->{output_file}") if (defined $self->{output_file});
}

sub getOutputFH
{
	my $self = shift;
	return $self->{fh};
}

1;
