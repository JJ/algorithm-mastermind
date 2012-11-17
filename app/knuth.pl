#!perl 

use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place

use Algorithm::MasterMind qw(check_combination partitions);
use Algorithm::MasterMind::Partition_Worst;
use YAML;

my $secret_code = shift || 'ADCB';
my @alphabet = qw( A B C D E F );
my $solver = new Algorithm::MasterMind::Partition_Worst { alphabet => \@alphabet,
							  length => length( $secret_code ) };

my $first_string = $solver->issue_first;
my $response =  check_combination( $secret_code, $first_string);
$solver->feedback( $response );
print Dump( $first_string, $response );
#print "Partitions \n", Dump( partitions( @{$solver->{'_consistent'}}) ), "\n\n";
my $played_string = $solver->issue_next;
while ( $played_string ne $secret_code ) {
  print "Partitions \n", Dump( partitions( @{$solver->{'_consistent'}}) ), "\n\n";
  $response =  check_combination( $secret_code, $played_string);
  print Dump( $played_string, $response );
  $solver->feedback( $response );
  $played_string = $solver->issue_next;
}
print "Final string $played_string\n";

