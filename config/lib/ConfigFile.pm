#
#===============================================================================
#
#         FILE: ConfigFile.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 08/19/2012 11:12:03 PM
#     REVISION: ---
#===============================================================================
package ConfigFile;
use strict;
use warnings;
use diagnostics;

use Data::Dumper;
use XML::Simple;

sub new
{
	my $proto = shift;
	my $class = (ref($proto) or $proto);
	my $self = {};

	my $args = shift;
	$self->{filename} = $args->{filename};

	bless $self, $class;
	$self->_init();
	return $self;
} 

sub get
{
	my $self = shift;
	my $xpath = shift;
	my $offset = shift || 0;

	# avoid out of bounds
	my $lastOffset = $#{$self->{xpath}->{$xpath}};
	if ($offset > $lastOffset)
	{
		$offset = $lastOffset;
	}
	elsif ($offset < (-1 * $lastOffset))
	{
		$offset = 0;
	}
	my $value = $self->{xpath}->{$xpath}->[$offset];
	return $value;
}

sub _init
{
	my $self = shift;
	if (defined $self->{filename} and -f $self->{filename})
	{
		$self->_read();
	}
}

sub _read
{
	my $self = shift;
	$self->{config} = XMLin($self->{filename}, ForceArray => 1, KeepRoot => 1, ForceContent => 1, KeyAttr => 0);
	$self->_buildXpathLookup({tree => $self->{config}})
}

sub _buildXpathLookup
{
	my $self = shift;	
	my $args = shift;
	my $tree = $args->{tree};
	my $xpath = $args->{xpath} || "";

	my $r = ref($tree);
	if ($r)
	{
		if ($r eq "HASH")
		{
			while(my ($k, $v) = each(%$tree))
			{
				my $currentXpath = $xpath . "/" . $k;
				$self->_buildXpathLookup({tree => $v, xpath => $currentXpath});
			}
		}
		elsif($r eq "ARRAY")
		{
			foreach my $hashRef (@$tree)
			{
				$self->_buildXpathLookup({tree => $hashRef, xpath => $xpath});
			}
		}	
	}
	else
	{
		$xpath =~ s:/content$::;
		push @{$self->{xpath}->{$xpath}}, $tree;
	}
	
}

1;
