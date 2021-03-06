package Algorithm::MasterMind::Player;

use warnings;
use strict;
use Carp;

use lib qw(../../lib ../../../lib);

use version; our $VERSION = qv("v0.0.1"); 

use base 'Exporter';
use Algorithm::MasterMind qw(check_combination);
use BSD::Resource qw(times);

our @EXPORT_OK = qw( play );

sub play {
  my $secret_code = shift || croak "No code";
  my $method = shift || croak "No method";
  my $method_options = shift || croak "No options";
  my $solver;
  eval "\$solver = new Algorithm::MasterMind::$method \$method_options"; ## no critic
  die "Can't instantiate $solver: $@\n" if !$solver;
  print "Code $secret_code\n";
  my $game = { code => $secret_code,
	       combinations => []};
  my $move = $solver->issue_first;
  my $response =  check_combination( $secret_code, $move);
  push @{$game->{'combinations'}}, [$move,$response] ;

  while ( $move ne $secret_code ) {
    $solver->feedback( $response );
    $move = $solver->issue_next;
    print "Playing $move\n";
    $response = check_combination( $secret_code, $move);
    push @{$game->{'combinations'}}, [$move, $response] ;
    $solver->feedback( $response );
    if ( $solver->{'_consistent'} ) {
      push @{$game->{'consistent_set'}}, [ keys %{$solver->{'_consistent'}} ] ;
    }  else {
      my $partitions = $solver->{'_partitions'};
      push @{$game->{'consistent_set'}}, 
	[ map( $_->{'_string'}, @{$partitions->{'_combinations'}}) ];
      if ( $partitions->{'_score'}->{'_most'} ) {
	push @{$game->{'top_scorers'}}, [ $partitions->top_scorers('most') ];
      } elsif ( $partitions->{'_score'}->{'_entropy'} ) {
	push @{$game->{'top_scorers'}}, [ $partitions->top_scorers('entropy') ];
      }
    }
    if ( $solver->{'_data'} ) {
      push @{$game->{'data'}}, $solver->{'_data'};
    }
  }
  
  $game->{'evaluations'} = $solver->evaluated();
  my @times = times();
  $game->{'times'} = [ @times[0,1] ];
  print "Finished\n";
  return $game;
}

"some blacks, all white"; # Magic true value required at end of module

__END__

=head1 NAME

Algorithm::MasterMind::Player - Instantiate and test solvers


=head1 SYNOPSIS

    use Algorithm::MasterMind::Player qw(play)

    my $secret_code = 'EAFC';
    my $population_size = 256;
    my $length = length( $secret_code );
    my @alphabet = qw( A B C D E F );
    play( $secret_code, "Canonical_GA", $method_options );

=head1 DESCRIPTION

Used as a test bed for algorithms.

=head1 INTERFACE 

=head2 play( $secret_code, $solver, $method_options )

Tries to find the secret code via the issued solver, and performs
basic tests on the obtained combinations. $solver will be expanded to
"Algorithm::Evolutionary::$solver" and instantiated to solve the problem

=head1 AUTHOR

JJ Merelo  C<< <jj@merelo.net> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2012, JJ Merelo C<< <jj@merelo.net> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
