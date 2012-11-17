#!/usr/bin/perl

use strict;
use warnings;

use lib qw(../lib ../../Algorithm-Evolutionary/lib ../../lib);

use YAML qw(LoadFile Dump);
use DateTime;

use Algorithm::MasterMind::Gamer qw( play );

my $config_file = shift || die "Usage: $0 <configfile.yaml>\n";

$config_file .= ".yaml" if ! ($config_file =~ /\.ya?ml$/);

my $conf = LoadFile($config_file) || die "Can't open $config_file: $@\n";

my $method = $conf->{'Method'};
my $method_options = $conf->{'Method_options'};
eval "require Algorithm::MasterMind::$method" || die "Can't load $method: $@\n";

my $secret_code= shift || die "Can't find combination\n";
my $repeats = $conf->{'repeats'} || 10;
for ( 1..$repeats ) {
  my $game = play( $secret_code, $method, $method_options );
  print Dump($game);
  for my $data ( qw( max_fitness avg_fitness entropy ) ) {
    print Dump( { $data => $game->{"_$data"} } );
  }
}

