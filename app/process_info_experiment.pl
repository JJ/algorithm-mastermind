#!/usr/bin/perl

use strict;
use warnings;

use IO::YAML;
use YAML qw(Load);

my $yaml_file = shift || die "I need an experiment file, no defaults\n";
my $results_io = IO::YAML->new($yaml_file, '<') || die "Can't open $yaml_file: $@\n";

print "Draw, #Consistent, Entropy\n";
while(defined(my $yaml = <$results_io>)) {
  my $these_results = YAML::Load($yaml);
  next if !(ref $these_results);
  next if !$these_results->{'code'};
  my $i = 1;
  for my $c (@{$these_results->{'combinations'}}) {
    my $info = $c->[2];
    if ( $info->{'consistent'} ) {
      print $i++, ", ", $info->{'consistent'},", ", $info->{'entropy'}, "\n";
    }
  }
}

  
