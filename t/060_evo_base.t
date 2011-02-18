#!perl 

use Test::More qw( no_plan ); #Random initial string...
use lib qw( lib ../lib ../../lib ../Algorithm-Evolutionary/lib ); #Just in case we are testing it in-place

use Algorithm::MasterMind qw(check_combination);

BEGIN {
	use_ok( 'Algorithm::MasterMind::Evolutionary' );
}

my $secret_code = 'EAFC';
my $population_size = 256;
my $length = length( $secret_code );
my @alphabet = qw( A B C D E F );
my $solver = new Algorithm::MasterMind::Evolutionary { alphabet => \@alphabet,
						       length => length( $secret_code ),
						       pop_size => $population_size};

$solver->reset;
is ( scalar( @{$solver->{'_pop'}}), $population_size, 'Pop size correct' );
my %unique_strings;
map( $unique_strings{$_->{'_str'}}=1, @{$solver->{'_pop'}} );
cmp_ok ( scalar (keys %unique_strings ), "==", $population_size, "Unique strings ". scalar (keys %unique_strings ) );
my $first_string = $solver->issue_first;
my $second_string = $solver->issue_first;
is( $first_string, $second_string, "Same first string" );

shift(@alphabet);
$solver->realphabet( @alphabet);
is( scalar( @{$solver->{'_pop'}->[0]->{'_chars'}}),
    scalar( @alphabet ), 'Realphabet' );
