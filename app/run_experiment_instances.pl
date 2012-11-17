#!/usr/bin/perl

use strict;
use warnings;

use lib qw(../lib ../../lib ../../Algorithm-Evolutionary/lib ../../../Algorithm-Evolutionary/lib);

use YAML qw(LoadFile);
use File::Slurp qw(read_file);
use IO::YAML;
use DateTime;

use Algorithm::MasterMind::Player qw( play );

my $config_file = shift || die "Usage: $0 <configfile.yaml>\n";
my $instances_file = shift || "../experiments/instances/instancias4_8.txt";

$config_file .= ".yaml" if ! ($config_file =~ /\.ya?ml$/);

my $conf = LoadFile($config_file) || die "Can't open $config_file: $@\n";

my $method = $conf->{'Method'};
eval "require Algorithm::MasterMind::$method" || die "Can't load $method: $@\n";

my $io = IO::YAML->new($conf->{'ID'}."-$method-".DateTime->now().".yaml", ">");

my $method_options = $conf->{'Method_options'};
$io->print( $method, $method_options );

#Load instances in numeric format x    y    z     z
my @alphabet = @{$method_options->{'alphabet'}};
my $instances = read_file( $instances_file) || die "Can't load $instances_file: $@\n"; 

my @combinaciones = split( /\n/, $instances );

while ( my $combination = shift @combinaciones ) {
  my $secret_code = join("",map( $alphabet[$_-1], split(/\s+/, $combination)));
  my $game = play( $secret_code,  $method, $method_options );
  $io->print($game);
  print "Finished\n";
}
$io->close;
