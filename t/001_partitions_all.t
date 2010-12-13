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

for my $secret_code ( @secret_codes ) {
  my $solver = new Algorithm::MasterMind::Partition::Worst { alphabet => \@alphabet,
							       length => length( $secret_code ) };
  my $first_string = $solver->issue_first;
  diag( "This might take a while while it finds the code $secret_code" );
  $solver->feedback( check_combination( $secret_code, $first_string) );
  my $second_solver = 
    Algorithm::MasterMind::Partition::Most->start_from(  { evaluated => $solver->{'_evaluated'},
							   alphabet => \@alphabet,
							   rules => $solver->{'_rules'},
							   consistent => $solver->{'_consistent'} } );
  my $played_string = $second_solver->issue_next;
  my $played = 2;
  while ( $played_string ne $secret_code ) {
      is( length( $played_string), length( $secret_code ), 'Playing '. $played_string ) ;
      $second_solver->feedback( check_combination( $secret_code, $played_string) );
      $played_string = $second_solver->issue_next;
  }
  is( $played_string, $secret_code, "Found code after ".$second_solver->evaluated()." combinations" );
}

for my $s (@stats) {
  my ($combinations, $games);
  for my $i ( @$s ) {
    $combinations += $i->[0];
    $games += $i->[1];
  }
  diag( "Average combinations " . $combinations / @$s  . " Games " . $games / @$s );
}
