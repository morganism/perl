#!/usr/bin/perl

use constant NUMBER_OF_TESTS =>7;
use Test::More tests => NUMBER_OF_TESTS;

BEGIN
{
	use lib $ENV{CONFIG_FILE_SRC} . "/lib";
	use_ok('ConfigFile');
}

use ConfigFile;
our $topDir = $ENV{CONFIG_FILE_SRC};

my $file = shift || "$topDir/bin/test.xml";

my $oConfigFile = new ConfigFile({filename=>$file});

note("Ensure ENV variable CONFIG_FILE_SRC is set correctly.");
ok(defined $ENV{CONFIG_FILE_SRC}, "ENV var CONFIG_FILE_SRC is defined");
like($ENV{CONFIG_FILE_SRC}, qr/config$/, "ENV var CONFIG_FILE_SRC look like correct location");

ok((-d "$ENV{CONFIG_FILE_SRC}/bin"), "directory bin exists");

ok(defined($oConfigFile) && ref $oConfigFile eq 'ConfigFile', "constructor");

my $v = $oConfigFile->get("/top/three");
ok($v eq 'content Three', 'get XPath value for /top/three');

$v = $oConfigFile->get("/top/two/attr2");
ok($v eq 'twoattr22', 'get XPath value for /top/two/attr');

done_testing(NUMBER_OF_TESTS);
