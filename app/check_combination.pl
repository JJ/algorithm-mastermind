#!/usr/bin/perl

use strict;
use warnings;
use v5.10;

use lib qw(../lib);

use Algorithm::MasterMind::Secret;

my $combinations = shift || 1000;
my $secrets = shift || 100;
my $length = shift || 8;
my @alphabet = qw(A B C D E F G H I J K L );

my @combinations;
for my $k (1..$combinations){
  push @combinations, random_combination();
}
my @secrets;
for my $k (1..$secrets){
  push @secrets, new Algorithm::MasterMind::Secret random_combination();
}

foreach my $i (@secrets) {
  foreach my $j (@combinations ) {
    $i->check( $j );
  }
  foreach my $j (@secrets) {
    for my $k (1..10) {
      my $result = { blacks => 0,
		     whites => 0};
      $i->check_secret( $j, $result );
    }
  }
}


####################################3
sub random_combination {
  my $string_to_play;
  for (my $i = 0; $i <  $length; $i++ ) {
    $string_to_play .= $alphabet[ rand( @alphabet) ];
  }
  return $string_to_play;
}
