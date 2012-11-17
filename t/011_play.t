#!perl 

use Test::More qw( no_plan ); #Random initial string...
use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place

use Algorithm::MasterMind qw(check_combination);

BEGIN {
	use_ok( 'Algorithm::MasterMind::Random' );
	use_ok( 'Algorithm::MasterMind::Player', ( 'play' ) );
}

my $secret_code = 'EAFC';
my @alphabet = qw( A B C D E F );
my $game = play( $secret_code, 'Random',  
		 { alphabet => \@alphabet,
		   length => length( $secret_code ) } );

is( ref($game), 'HASH', 'Game OK' );
is( $game->{'code'}, $secret_code, 'Code OK');
my @combinations = @{$game->{'combinations'}};

is( $combinations[$#combinations]->[0], $secret_code, 'Found OK' );
is( $combinations[$#combinations]->[1]->{'whites'}, 0, 'Found OK' );



