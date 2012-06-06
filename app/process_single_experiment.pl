#!/usr/bin/perl

use strict;
use warnings;

use IO::YAML;
use YAML qw(Load);

use Statistics::Basic qw(:all);

my $yaml_file = shift || die "I need an experiment file, no defaults\n";
my $results_io = IO::YAML->new($yaml_file, '<') || die "Can't open $yaml_file: $@\n";

my $index = 0;
my $resultados;
my $max_res = 0;
while(defined(my $yaml = <$results_io>)) {
  my $these_results = YAML::Load($yaml);
  next if $these_results->{'code'};
  my $param = (keys %{$these_results})[0];
  my $size = scalar @{$these_results->{$param}};
  $max_res = ( $size > $max_res)? $size: $max_res;
  for (my $i = 0; $i < @{$these_results->{$param}}; $i ++ ) {
    push @{$resultados->{$param}->[$i]}, $these_results->{$param}->[$i];
  }
}

print join("; ", keys %$resultados ), "\n";
for (my $i = 0; $i < $max_res; $i++ ) {
  for my $r ( keys %$resultados ) {
    print mean( $resultados->{$r}->[$i] ), "; ";
  }
  print "\n";
}
