#!perl 

use Test::More qw( no_plan ); #Random initial string...
use lib qw( lib ../lib ../../lib ../Algorithm-Evolutionary/lib ); #Just in case we are testing it in-place

use Algorithm::MasterMind::Test_Solver qw( solve_mastermind );
use File::Slurp qw(write_file);

BEGIN {
	use_ok( 'Algorithm::MasterMind::EvoRank_Vis' );
}

my @secret_codes = qw( AAAA ABCD CDEF ACAC BAFE FFFF);
my @stats;
my @alphabet = qw( A B C D E F );
my $population_size = 256;

for my $secret_code ( @secret_codes ) {

  my $solver = new Algorithm::MasterMind::EvoRank_Vis { alphabet => \@alphabet,
						      length => length( $secret_code ),
							pop_size => $population_size,
							  replacement_rate => 0.5 };

  solve_mastermind( $solver, $secret_code );
  my $gif = $solver->terminate_and_return_gif();
  is( $gif ne undef, 1, "Gif OK");
  write_file("$secret_code-r05.gif",{binmode => ':raw' },$gif);

  $solver = new Algorithm::MasterMind::EvoRank_Vis { alphabet => \@alphabet,
						   length => length( $secret_code ),
						     pop_size => $population_size,
						       permutation_rate => 2 };
  solve_mastermind( $solver, $secret_code );
  $gif = $solver->terminate_and_return_gif();
  is( $gif ne undef, 1, "Gif OK");
  write_file("$secret_code-p2.gif",{binmode => ':raw' },$gif);

}

for my $s (@stats) {
  my ($combinations, $games);
  for my $i ( @$s ) {
    $combinations += $i->[0];
    $games += $i->[1];
  }
  diag( "Average combinations " . $combinations / @$s  . " Games " . $games / @$s );
}
