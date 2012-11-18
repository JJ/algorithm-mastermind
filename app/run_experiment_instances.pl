#!/usr/bin/perl

=head1 NAME

run_experiment_instances.pl - Testbed for evolutionary algorithms

=head1 SYNOPSIS

  bash% ./run_experiment_instances config-file.yaml instances_file.txt

=head1 DESCRIPTION  

This script uses L<Algorithm::Mastermind::Player> for playing a set of
mastermind games, one per instance. It produces a rather verbose .yaml
file with information on games played.

=cut 

=head1 SEE ALSO

First, you should obviously check, L<Algorithm::MasterMind>, and maybe
also L<Algorithm::Evolutionary::Player );

=head1 AUTHOR

J. J. Merelo, C<jj (at) merelo.net>

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

=cut

use strict;
use warnings;

use lib qw(../lib ../../lib ../../Algorithm-Evolutionary/lib ../../../Algorithm-Evolutionary/lib);

use YAML qw(LoadFile);
use File::Slurp qw(read_file write_file);
use IO::YAML;
use DateTime;

use Algorithm::MasterMind::Player qw( play );

my $config_file = shift || die "Usage: $0 <configfile.yaml>\n";
my $instances_file = shift || "../experiments/instances/instancias4_8.txt";
my $output_dir = shift || "."; 

$config_file .= ".yaml" if ! ($config_file =~ /\.ya?ml$/);

my $conf = LoadFile($config_file) || die "Can't open $config_file: $@\n";

my $method = $conf->{'Method'};
eval "require Algorithm::MasterMind::$method" || die "Can't load $method: $@\n"; #early warning

my $slug = $conf->{'ID'}."-$method-".DateTime->now();
my $io = IO::YAML->new("$output_dir/$slug.yaml", ">");

my @data = (['Evaluations','Played','Time']);

my $method_options = $conf->{'Method_options'};
$io->print( $method, $method_options );

#Load instances in numeric format x    y    z     z
my @alphabet = @{$method_options->{'alphabet'}};
my $instances = read_file( $instances_file) || die "Can't load $instances_file: $@\n"; 

my @combinaciones = split( /\n/, $instances );

my $last_time = 0;
while ( my $combination = shift @combinaciones ) {
  my $secret_code = join("",map( $alphabet[$_-1], split(/\s+/, $combination)));
  my $game = play( $secret_code,  $method, $method_options );
  push @data, [ $game->{'evaluations'}, 
		scalar @{$game->{'combinations'}} , 
		$game->{'times'}[0] - $last_time ];
  $last_time = $game->{'times'}[0];
  $io->print($game);
  print "Finished\n";
}
write_file( "$output_dir/res-$slug.dat", map( join(",",@$_)."\n", @data ));
$io->close;
