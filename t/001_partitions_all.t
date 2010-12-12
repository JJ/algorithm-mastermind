#!perl 

use Test::More qw( no_plan ); #Random initial string...
use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place

use Algorithm::MasterMind qw(check_combination);
use Algorithm::MasterMind::Test_Solver qw( solve_mastermind );

BEGIN {
	use_ok( 'Algorithm::MasterMind::Partition::Worst' );
	use_ok( 'Algorithm::MasterMind::Partition::Most' );
}

my @secret_codes = qw( AAAA ABCD CDEF ACAC BAFE FFFF);
my @stats;

my $secret_code = 'ADCB';
my @alphabet = qw( A B C D E F );

for my $secret_code ( @secret_codes ) {
  my $solver = new Algorithm::MasterMind::Partition::Worst { alphabet => \@alphabet,
							       length => length( $secret_code ) };
  push @{$stats[0]}, solve_mastermind( $solver, $secret_code );

  $solver = new Algorithm::MasterMind::Partition::Most { alphabet => \@alphabet,
							   length => length( $secret_code ) };
  push @{$stats[1]}, solve_mastermind( $solver, $secret_code );
}

for my $s (@stats) {
  my ($combinations, $games);
  for my $i ( @$s ) {
    $combinations += $i->[0];
    $games += $i->[1];
  }
  diag( "Average combinations " . $combinations / @$s  . " Games " . $games / @$s );
}
