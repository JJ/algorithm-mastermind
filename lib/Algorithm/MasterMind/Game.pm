package Algorithm::MasterMind::Game;

use warnings;
use strict;
use Carp qw(croak);

use lib qw( ../../lib ../lib ../../../lib);

use Algorithm::MasterMind qw(response_as_string);
use Algorithm::MasterMind::Secret;

# Module implementation here

sub new {

  my $class = shift;
  my $secret = shift || croak "No default string\n";

  my $self =  { _secret => new Algorithm::MasterMind::Secret $secret,
		_moves => [] };
  bless $self, $class;
  return $self;
}

sub secret {
  return shift->{'_secret'};
}

sub check_code {
  my $self = shift;
  my $move = shift;
  return $self->{'_secret'}->check( $move );
}

sub add_move {
  my $self = shift;
  my $move = shift || croak "No move ";
  my $response = shift;
  push @{$self->{'_moves'}}, 
    { move => Algorithm::MasterMind::Secret->new( $move ) ,
      response => $response,
      response_as_string => response_as_string( $response )};

}

sub check_moves {
  my $self = shift;
  my $code = shift || croak "No code ";
  my $result = { matches => 0,
		 result => [] };
  for my $r ( @{$self->{'_moves'}} ) {
    my $copy = $code;
    my $rule_result = $r->{'move'}->check( $copy );
    $result->{'matches'}++
      if ( response_as_string( $rule_result ) eq $r->{'response_as_string'} );
    push @{ $result->{'result'} }, $rule_result;
  }
  return $result;
}


"Can't tell"; # Magic true value required at end of module

__END__

=head1 NAME

Algorithm::MasterMind::Secret - Minimal framework for MM secrets


=head1 SYNOPSIS

    use Algorithm::MasterMind::Secret;

    my $sikrit = new Algorithm::MasterMind::Secret 'ABCD';

    my $blacks_whites = $sikrit->check('BBBB'}

=head1 DESCRIPTION

Basically a string and a hash, caches the string in a hash so that it
is faster to check against it in mastermind. This class is heavily
optimized for speed, which might result in some inconvenients. 

=head1 INTERFACE 

=head2 new ( $string )

A string in an arbitrary alphabet, but should be the same as the ones
you will use to solve

=head2 check( $string )

Checks a combination against the secret code, returning a hashref with
the number of blacks (correct in position) and whites (correct in
color, not position). The string must be a variable, and it is
_destroyed_ , which makes it marginally faster. So don't count on the
variable after the call. 

=head1 CONFIGURATION AND ENVIRONMENT

Algorithm::MasterMind requires no configuration files or environment variables.


=head1 DEPENDENCIES

L<Algorithm::Evolutionary>, but only for one of the
strategies. L<Algorithm::Combinatorics>, used to generate combinations
and for exhaustive search strategies. 


=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-algorithm-mastermind@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 SEE ALSO

Other modules in CPAN which you might find more useful than this one
are at L<Games::Mastermind::Solver>, which I didn't use and extend for
no reason, although I should. Also L<Games::Mastermind::Cracker>

You can try and play this game at
http://geneura.ugr.es/~jmerelo/GenMM/mm-eda.cgi, restricted to 4 pegs
and 6 colors. The program C<mm-eda.cgi> should also be available in
the C<apps> directory of this distribution.

The development of this projects is hosted at sourceforge,
https://sourceforge.net/projects/opeal/develop, check it out for the
    latest bleeding edge release. 

If you use any of these modules for your own research, we would very
grateful if you would reference the papers that describe this, such as
this one:

 @article{merelo2010finding,
  title={{Finding Better Solutions to the Mastermind Puzzle Using Evolutionary Algorithms}},
  author={Merelo-Guerv{\'o}s, J. and Runarsson, T.},
  journal={Applications of Evolutionary Computation},
  pages={121--130},
  year={2010},
  publisher={Springer}
 }


=head1 AUTHOR

JJ Merelo  C<< <jj@merelo.net> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2009, JJ Merelo C<< <jj@merelo.net> >>. All rights reserved.

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
