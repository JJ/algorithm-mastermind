#!perl 

use Test::More qw( no_plan ); #Random initial string...
use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place
use Algorithm::MasterMind qw(random_string);
BEGIN {
	use_ok( 'Algorithm::MasterMind::Consistent_Set' );
}

my $size = 32;
my @alphabet = qw( A B C D E F );
my $length = 4;

my @strings;
for (1..$size) {
  push @strings, random_string( \@alphabet, $length);
}

my $c_set = new Algorithm::MasterMind::Consistent_Set( \@strings );

for my $s (@strings ) {
  ok( $c_set->is_in( $s ), 'Added');
}

my $new_random_string = (  random_string( \@alphabet, $length) );
$c_set->add_combination( $new_random_string );
ok( $c_set->is_in( $new_random_string ), 'Added');

@strings = qw(AAAA BBBB CCCC ABCD);
$c_set = new Algorithm::MasterMind::Consistent_Set( \@strings );
my %partitions = (   
		  'AAAA' =>  { '0b-0w' => 2,
			       '1b-0w' => 1},
		  'ABCD' =>{ '1b-0w' => 3 },
		  'BBBB' => { '0b-0w' => 2,
			      '1b-0w' => 1 },
		  'CCCC' => { '0b-0w' => 2,
			      '1b-0w' => 1 } );
for my $s (@strings) {
  is_deeply($c_set->partitions_for($s), $partitions{$s}, "Partitions for $s" );
}
my $secret = new Algorithm::MasterMind::Secret 'ABEE';
my $result = $secret->check('DDDD'); # Simulating move
$c_set->cull_inconsistent_with( 'DDDD', $result );
is_deeply($c_set->partitions_for('AAAA'), { '0b-0w' => 2 }, "New partitioning" );
