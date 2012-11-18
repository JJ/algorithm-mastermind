#!/usr/bin/perl

=head1 NAME

run_several_experiment_instances.pl - Testbed for evolutionary
algorithms. Runs a battery of experimens

=head1 SYNOPSIS

  bash% ./run_several_experiments_instances config-file.yaml instances_file.txt output_dir

=head1 DESCRIPTION  

This script spawns run_experiment_instances.pl , one per variation

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

use YAML qw(LoadFile DumpFile);
use File::Slurp qw(read_file write_file);
use Clone qw(clone);
use DateTime;

use Algorithm::MasterMind::Player qw( play );

my $config_file = shift || die "Usage: $0 <configfile.yaml> [instancesfile] [outputdir]\n";
my $instances_file = shift || "../experiments/instances/instancias4_8.txt";
my $output_dir = shift || "."; 

$config_file .= ".yaml" if ! ($config_file =~ /\.ya?ml$/);

my $conf = LoadFile($config_file) || die "Can't open $config_file: $@\n";
my $method = $conf->{'Method'};
my $slug = $conf->{'ID'}."-$method-".DateTime->now();

my $method_options = $conf->{'Method_options'};

my  $key;
# Look for varying key
for my $m ( keys %$method_options ) {
  if ( $m ne 'alphabet' ) {
    if ( ref $method_options->{$m} ne '') {
      $key = $m;
    }
  }
}

for my $k ( @{$method_options->{$key}} ) {
  #create conf file
  my $this_conf = clone( $conf );
  $this_conf->{'Method_options'}->{$key} = $k;
  $this_conf->{'ID'} = $this_conf->{'ID'}."-$key:$k-";
  DumpFile( "$output_dir/conf-$slug.yaml", $this_conf );
  print "Running  ./run_experiment_instances.pl $output_dir/conf-$slug.yaml $instances_file $output_dir\n";
  `./run_experiment_instances.pl $output_dir/conf-$slug.yaml $instances_file $output_dir`;
}
