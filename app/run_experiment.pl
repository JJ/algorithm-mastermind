#!/usr/bin/perl

use strict;
use warnings;

use lib qw(../lib ../../Algorithm-Evolutionary/lib);

use YAML qw(LoadFile);
use IO::YAML;
use DateTime;
use Data::Dumper qw(Dumper);

my $config_file = shift || die "Usage: $0 <configfile.yaml>\n";

$config_file .= ".yaml" if ! ($config_file =~ /\.ya?ml$/);

my $conf = LoadFile($config_file) || die "Can't open $config_file: $@\n";

my $method = $conf->{'Method'};
eval {
  require( "Algorithm::MasterMind::$method");
}|| die "Can't load $method: $@\n";

my $io = IO::YAML->new($conf->{'ID'}."-$method-".DateTime->now().".yaml", ">");
my $method_options = $conf->{'Method_options'};

for my $i (1..$conf->{'tests'}) {
  
  my $solver;
  eval "\$solver = new Algorithm::MasterMind::$method ".Dumper($method_options);
  die "Can't instantiate $solver: $@\n";
  my $secret_code = $solver->random_combination();
  $io->print( $secret_code );
  my $first_string = $solver->issue_first;
  my $response =  check_combination( $secret_code, $first_string);
  $io->print( [$first_string,$response] );

  $solver->feedback( $response );
    
  my $played_string = $solver->issue_next;
  while ( $played_string ne $secret_code ) {
      $response = check_combination( $secret_code, $played_string);
      $io->print( [$played_string, $response] );
      $solver->feedback( $response );
      print p(print_combination($played_string, $response )), "\n";
      $played_string = $solver->issue_next;      
    }  
  $io->print( combinations => $solver->evaluated() );
  $io->terminate;
}
$io->close;
