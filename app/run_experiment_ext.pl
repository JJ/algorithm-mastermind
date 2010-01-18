#!/usr/bin/perl

use strict;
use warnings;

use lib qw(../lib ../../Algorithm-Evolutionary/lib);

use YAML qw(LoadFile Dump);
use DateTime;
use Algorithm::Combinatorics qw(variations_with_repetition);
use IO::File;
use Algorithm::MasterMind qw( check_combination );

my $config_file = shift || die "Usage: $0 <configfile.yaml>\n";

$config_file .= ".yaml" if ! ($config_file =~ /\.ya?ml$/);

my $conf = LoadFile($config_file) || die "Can't open $config_file: $@\n";

my $method = $conf->{'Method'};
my $io = new IO::File $conf->{'ID'}."-$method-".DateTime->now().".yaml", ">" ;

my $method_options = $conf->{'Method_options'};
$io->print( Dump($method));
$io->print( Dump( $method_options) );

my $engine = variations_with_repetition($method_options->{'alphabet'}, 
					$method_options->{'length'});

my $combination;
my $repeats = $conf->{'repeats'} || 10;
while ( $combination = $engine->next() ) {
  my $secret_code = join("",@$combination);
  my $yaml = `./run_single_experiment.pl $config_file $secret_code`;
  $io->print("$yaml\n---\n");
}
$io->close;
