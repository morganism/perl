#!/usr/bin/perl 
#===============================================================================
#
#         FILE: test.pl
#
#        USAGE: ./test.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 08/19/2012 11:22:14 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

use Data::Dumper;

use lib "../lib";
use ConfigFile;
my $file = shift || "/home/morgan/src/git/perl/config/bin/test.xml";

my $c = new ConfigFile({filename=>$file});
print Dumper($c->{xpath});
