#!/usr/bin/perl

use Test::Simple tests => 2;

use lib $ENV{CONFIG_FILE_SRC} . "/lib";
use ConfigFile;

my $file = shift || $ENV{CONFIG_FILE_SRC} . "/bin/test.xml";

my $oConfigFile = new ConfigFile({filename=>$file});
my $v = $oConfigFile->get("/top/three");

ok(defined($oConfigFile) && ref $oConfigFile eq 'ConfigFile', "new() works");
ok($v eq 'content Three', 'get() works');

