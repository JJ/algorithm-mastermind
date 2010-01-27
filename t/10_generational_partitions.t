#!perl 

use Test::More qw( no_plan ); #Random initial string...
use lib qw( lib ../lib ../../lib 
	    ../Algorithm-Evolutionary/lib 
	    ../../Algorithm-Evolutionary/lib 
	    ../../../Algorithm-Evolutionary/lib ); #Just in case we are testing it in-place

use Algorithm::MasterMind qw(check_combination);
use Algorithm::MasterMind::Test_Solver qw( solve_mastermind );
use Algorithm::Evolutionary qw( Op::String_Mutation
				Op::QuadXOver
				Op::CanonicalGA
				Op::Permutation
				Op::Easy
				Op::Uniform_Crossover);
BEGIN {
	use_ok( 'Algorithm::MasterMind::Generational_Partitions' );
}

my $secret_code = 'EAFC';
my $population_size = 256;
my $length = length( $secret_code );
my @alphabet = qw( A B C D E F );

my $m = new Algorithm::Evolutionary::Op::String_Mutation; # Rate = 1
my $c = Algorithm::Evolutionary::Op::QuadXOver->new( 1,4 ); 
my $p = new Algorithm::Evolutionary::Op::Permutation;
my $x = new Algorithm::Evolutionary::Op::Uniform_Crossover( 0.5, 4);

my @solvers = (Algorithm::MasterMind::Generational_Partitions->new( 'Easy',
								    [0.5, [$m, $p, $x]],
								     { alphabet => \@alphabet,
								       length => length( $secret_code ),
								       pop_size => $population_size} ),
		
	       Algorithm::MasterMind::Generational_Partitions->new( 'CanonicalGA',
								     [ 0.4, [$m, $c] ],
								     { alphabet => \@alphabet,
								       length => length( $secret_code ),
								       pop_size => $population_size} ),
		
		Algorithm::MasterMind::Generational_Partitions->new( 'CanonicalGA',
								     [ 0.2, [$m, $c] ],
								     { alphabet => \@alphabet,
								       length => length( $secret_code ),
								       pop_size => $population_size/2} ) 
								     
		 );
		
for my $s ( @solvers ) {
  solve_mastermind( $s, $secret_code );
}


