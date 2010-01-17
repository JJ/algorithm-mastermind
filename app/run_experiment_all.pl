#!/usr/bin/perl

use strict;
use warnings;

use lib qw(../lib ../../Algorithm-Evolutionary/lib);

use YAML qw(LoadFile);
use IO::YAML;
use DateTime;
use Algorithm::Combinatorics qw(variations_with_repetition);

use Algorithm::MasterMind qw( check_combination );

my $config_file = shift || die "Usage: $0 <configfile.yaml>\n";

$config_file .= ".yaml" if ! ($config_file =~ /\.ya?ml$/);

my $conf = LoadFile($config_file) || die "Can't open $config_file: $@\n";

my $method = $conf->{'Method'};
eval "require Algorithm::MasterMind::$method" || die "Can't load $method: $@\n";

my $io = IO::YAML->new($conf->{'ID'}."-$method-".DateTime->now().".yaml", ">");

my $method_options = $conf->{'Method_options'};
$io->print( $method, $method_options );

my $engine = variations_with_repetition($method_options->{'alphabet'}, 
					$method_options->{'length'});

my $combination;
my $repeats = $conf->{'repeats'} || 10;
while ( $combination = $engine->next() ) {
  my $secret_code = join("",@$combination);
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
    print "Code $secret_code\n";
    my $played_string = $solver->issue_next;
    while ( $played_string ne $secret_code ) {
      print "Playing $played_string\n";
      $response = check_combination( $secret_code, $played_string);
      push @{$game->{'combinations'}}, [$played_string, $response] ;
      $solver->feedback( $response );
      $played_string = $solver->issue_next;      
    }  
    $game->{'evaluations'} = $solver->evaluated();
    $io->print($game);
    print "Finished\n";
  }
}
$io->close;
