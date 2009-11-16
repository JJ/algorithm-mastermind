#!perl 

use strict;
use warnings;

use Test::More tests => 3;
use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place

use Algorithm::MasterMind qw(partitions);
use Algorithm::MasterMind::Test;

use Algorithm::Combinatorics qw(variations_with_repetition);

diag( "This could take a while \n" );

my $length= 4;
my @alphabet = qw( A B C D );

my $mastermind = new Algorithm::MasterMind::Test( {alphabet => \@alphabet, 
						   length => $length} );

my @combinations = $mastermind->all_combinations;
is ( $combinations[$#combinations], $alphabet[$#alphabet]x$length, 
     "Combinations generated"),

my $partitions = partitions( @combinations ) ;

is( keys %$partitions, @combinations, "Number of partitions" );
my $engine = variations_with_repetition( \@alphabet, $length);
my $first_combo = join("",@{$engine->next()});

my $number_of_combos= 0;
for my $p ( keys %{$partitions->{$first_combo}} ) {
  $number_of_combos += $partitions->{$first_combo}{$p}
}
is ( $number_of_combos, $#combinations, "Number of combinations" );
