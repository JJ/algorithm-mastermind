#!/usr/bin/perl

use strict;
use warnings;

use IO::YAML;
use YAML qw(Load);

my $yaml_file = shift || die "I need an experiment file, no defaults\n";
my $results_io = IO::YAML->new($yaml_file, '<') || die "Can't open $yaml_file: $@\n";

my @code_by_combination;
while(defined(my $yaml = <$results_io>)) {
  my $these_results = YAML::Load($yaml);
  my $played = @{$these_results->{'combinations'}}+1;
  if (!$code_by_combination[$played] ) {
    $code_by_combination[$played] = [];
  }
  push @{$code_by_combination[$played]} , $these_results->{'code'};
}

for ( my $i = 0; $i <= $#code_by_combination; $i++ ) {
  if ($code_by_combination[$i] ) {
    print "* $i : ", join( " ", @{$code_by_combination[$i]} ), "\n";
  }
}

  
