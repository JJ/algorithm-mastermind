#!/usr/bin/perl

use strict;
use warnings;

use lib qw(../lib ../../Algorithm-Evolutionary/lib ../../lib);

use YAML qw(LoadFile Dump);
use DateTime;
use Algorithm::Combinatorics qw(variations_with_repetition);

use Algorithm::MasterMind qw( check_combination );

my $config_file = shift || die "Usage: $0 <configfile.yaml>\n";

$config_file .= ".yaml" if ! ($config_file =~ /\.ya?ml$/);

my $conf = LoadFile($config_file) || die "Can't open $config_file: $@\n";

my $method = $conf->{'Method'};
my $method_options = $conf->{'Method_options'};
eval "require Algorithm::MasterMind::$method" || die "Can't load $method: $@\n";

my $secret_code= shift || die "Can't find combination\n";
my $repeats = $conf->{'repeats'} || 10;
for ( 1..$repeats ) {
  my $solver;
  eval "\$solver = new Algorithm::MasterMind::$method \$method_options";
  die "Can't instantiate $solver: $@\n" if !$solver;
  my $game = { code => $secret_code,
	       combinations => []};
  my $first_string = $solver->issue_first;
  my $response =  check_combination( $secret_code, $first_string);
  push @{$game->{'combinations'}}, [$first_string,$response] ;
    
  $solver->feedback( $response );
  my $played_string = $solver->issue_next;
  while ( $played_string ne $secret_code ) {
    $response = check_combination( $secret_code, $played_string);
    push @{$game->{'combinations'}}, [$played_string, $response] ;
    $solver->feedback( $response );
    $played_string = $solver->issue_next;      
  }  
  $game->{'evaluations'} = $solver->evaluated();
  print Dump($game);
  for my $data qw( max_fitness avg_fitness entropy ) {
    print Dump( { $data => $solver->{"_$data"} } );
  }
}

