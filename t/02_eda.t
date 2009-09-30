#!perl 

use Test::More qw( no_plan ); #Random initial string...
use lib qw( lib ../lib ../../lib ../Algorithm-Evolutionary/lib ); #Just in case we are testing it in-place

use Algorithm::MasterMind qw(check_combination);

BEGIN {
	use_ok( 'Algorithm::MasterMind::EDA' );
}

my $secret_code = 'EAFC';
my $population_size = 200;
my @alphabet = qw( A B C D E F );
my $solver = new Algorithm::MasterMind::EDA { alphabet => \@alphabet,
						length => length( $secret_code ),
						  pop_size => $population_size};

isa_ok( $solver, 'Algorithm::MasterMind::EDA', 'Instance OK' );

my $first_string = $solver->issue_first;
diag( "This might take a while while it finds the code $secret_code" );
is( length( $first_string), 4, 'Issued first '. $first_string );
$solver->feedback( check_combination( $secret_code, $first_string) );
is( scalar $solver->number_of_rules, 1, "Rules added" );
my $played_string = $solver->issue_next;
while ( $played_string ne $secret_code ) {
  is( length( $played_string), 4, 'Playing '. $played_string ) ;
  $solver->feedback( check_combination( $secret_code, $played_string) );
  $played_string = $solver->issue_next;
}
is( $played_string, $secret_code, "Found code after ".$solver->evaluated()." combinations" );

$solver = new Algorithm::MasterMind::EDA { alphabet => \@alphabet,
					     length => length( $secret_code ),
					       pop_size => $population_size,
					     orig => 1};

$first_string = $solver->issue_first;
diag( "This might take a while while it finds the code $secret_code" );
is( length( $first_string), 4, 'Issued first '. $first_string );
$solver->feedback( check_combination( $secret_code, $first_string) );
$played_string = $solver->issue_next;
while ( $played_string ne $secret_code ) {
  is( length( $played_string), 4, 'Playing '. $played_string ) ;
  $solver->feedback( check_combination( $secret_code, $played_string) );
  $played_string = $solver->issue_next;
}
is( $played_string, $secret_code, "Found code after ".$solver->evaluated()." combinations" );
