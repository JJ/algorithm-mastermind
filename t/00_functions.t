#!perl 

use Test::More tests => 16;
use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place

BEGIN {
	use_ok( 'Algorithm::MasterMind' );
	use_ok( 'Algorithm::MasterMind::Test' );
	BEGIN { use_ok('Algorithm::MasterMind', qw(check_combination)); };

}

diag( "Testing Algorithm::Evolutionary $Algorithm::Evolutionary::VERSION, Perl $], $^X" );

my @combinations = qw( AAAA AABB AAAB ABCD ABCD);
my @strings = qw( ABBB BBAA BAAA BADC ABCD);
my @results = ( { blacks => 1,
		  whites => 0 },
		{ blacks => 0,
		  whites => 4 },
		{ blacks => 2,
		  whites => 2 },
		{ blacks => 0,
		  whites => 4 },
		{ blacks => 4,
		  whites => 0 } );

while (@combinations ) {
  my $combination = shift @combinations;
  my $string = shift @strings;
  my $result = shift @results;
  my $result_obtained = check_combination( $combination, $string );
  is_deeply( $result_obtained, $result, "$string vs $combination");
}

#Mock play
my $code = 'BCAD';
my @played = qw( ABCA BCAE BBAD BCAD );

my $mm = new Algorithm::MasterMind::Test { options => ''};
my $number_of_rules = 0;
my @matches = qw( 0 1 0 3);
for my $p ( @played ) {
  my $matches = $mm->matches( $p );
  is( $matches->{'matches'}, shift @matches, "Matching" );
  my $result = check_combination( $code, $p );
  $mm->add_rule( $p, $result );
  $number_of_rules++;
  is( $mm->number_of_rules(), $number_of_rules, "Rule added ".$matches->{'matches'} );
}