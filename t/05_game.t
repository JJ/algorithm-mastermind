#!perl 

use Test::More qw( no_plan ); #Random initial string...
use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place
use Algorithm::MasterMind qw(random_string);
use Algorithm::MasterMind::Secret;

BEGIN {
	use_ok( 'Algorithm::MasterMind::Game' );
}

my @alphabet = qw( A B C D E F );
my $length = 4;
my $size = 8;

my @strings;
for (1..$size) {
  push @strings, random_string( \@alphabet, $length);
}

my $secret = random_string( \@alphabet, $length);

my $game = new Algorithm::MasterMind::Game ($secret);
isa_ok( $game, 'Algorithm::MasterMind::Game', "Class OK");

is( $game->secret->{'_string'}, $secret, "Secret OK" );
my $secret_obj = new Algorithm::MasterMind::Secret $secret;

for my $s ( @strings ) {
  my $string = $s;
  my $result = $game->check_code( $string );
  is_deeply( $secret_obj->check( $string ), $result, "Checking $s OK");
  $game->add_move( $s, $result );
  my $check_result = $game->check_moves( $s );
  ok( @{$check_result->{'result'}}  > 0, "Check game $s OK" );
}

