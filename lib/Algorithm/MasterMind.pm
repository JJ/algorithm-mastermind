package Algorithm::MasterMind;

use warnings;
use strict;
use Carp;

use version; our $VERSION = qv('0.0.2');

our @ISA = qw(Exporter);

our @EXPORT_OK = qw( check_combination );

use lib qw( ../../lib ../lib ../../../lib );

# Module implementation here

sub new {

  my $class = shift;
  my $options = shift || croak "Need options here in Algorithm::MasterMind::New\n";

  my $self =  { _rules => [],
		_evaluated => 0 };

  bless $self, $class;
  $self->initialize( $options );
  return $self;
}

sub random_combination {
  my $self = shift;
  my $string_to_play;
  my @alphabet = @{ $self->{'_alphabet'} };
  for (my $i = 0; $i <  $self->{'_length'}; $i++ ) {
    $string_to_play .= $alphabet[ rand( @alphabet) ];
  }
  return $string_to_play;
}

sub issue_first { #Default implementation
  my $self = shift;
  return $self->{'_last'} = $self->random_combination;
}

sub issue_next {
  croak "To be reimplemented in derived classes";
}

sub add_rule {
  my $self = shift;
  my ($combination, $result) = @_;
  $result->{'combination'} = $combination;
  push @{ $self->{'_rules'} }, $result;

}

sub feedback {
  my $self = shift;
  my ($result) = @_;
  $self->add_rule( $self->{'_last'}, $result );
}

sub number_of_rules {
  my $self= shift;
  return scalar @{ $self->{'_rules'}};
}

sub rules {
  my $self= shift;
  return   $self->{'_rules'};
}

sub evaluated {
  my $self=shift;
  return $self->{'_evaluated'};
}

sub matches {

  my $self = shift;
  my $string = shift || croak "No string\n";
  my @rules = @{$self->{'_rules'}};
  my $result = { matches => 0,
		 result => [] };

  for my $r ( @rules ) {    
    my $rule_result = check_rule( $r, $string );
    $result->{'matches'}++ if ( $rule_result->{'match'} );
    push @{ $result->{'result'} }, $rule_result;
  }
  $self->{'_evaluated'}++;
  return $result;
}

sub check_rule {
  my $rule = shift;
  my $string = shift;
  my $result = check_combination( $rule->{'combination'}, $string );
  if ( $rule->{'blacks'} eq $result->{'blacks'} 
       && $rule->{'whites'} eq $result->{'whites'} ) {
    $result->{'match'} = 1;
  } else {
    $result->{'match'} = 0;
  }
  return $result;
}

sub check_combination {
  my $combination = shift;
  my $string = shift;
  my $blacks = 0;
  for ( my $i = 0; $i < length($combination); $i ++ ) {
    if ( substr( $combination, $i, 1 ) eq substr( $string, $i, 1 ) ) {
      substr( $combination, $i, 1 ) = substr( $string, $i, 1 ) = 0;
      $blacks++;
    }
  }
  my %hash_combination = hashify( $combination );
  my %hash_string = hashify( $string );
  my $whites = 0;
  for my $k ( keys %hash_combination ) {
    next if $k eq '0';
    next if ! defined $hash_string{$k};
    $whites += ($hash_combination{$k} > $hash_string{$k})
      ?$hash_string{$k}
	:$hash_combination{$k};
  }
  return { blacks => $blacks,
	   whites => $whites };
}

sub hashify {
  my $str = shift;
  my %hash;
  map( $hash{$_}++, split(//, $str));
  return %hash;
}

sub not_in_combination {
  my $self = shift;
  my $combination = shift;
  my @alphabet = @{$self->{'_alphabet'}};
  my %alphabet_hash;
  map( $alphabet_hash{$_}=1, @alphabet );
  for my $l ( split(//, $combination ) ) {
    delete $alphabet_hash{$l} if  $alphabet_hash{$l};
  }
  return keys %alphabet_hash;
}


"4 blacks, 0 white"; # Magic true value required at end of module

__END__

=head1 NAME

Algorithm::MasterMind - Framework for algorithms that solve the MasterMind game


=head1 VERSION

This document describes Algorithm::MasterMind version 0.0.1


=head1 SYNOPSIS

    use Algorithm::MasterMind;

    my $solver = new Algorithm::MasterMind::Solver $options;

    my $first_string = $solver->issue_first();
    $solver->feedback( check_combination( $secret_code, $first_string) );

    my $played_string = $solver->issue_next;
    $solver->feedback( check_combination( $secret_code, $played_string) );

    #And so on until solution is found
  
=head1 DESCRIPTION

Includes common functions used in Mastermind solvers; it should not be
used directly, but from derived classes. See examples in
L<Algorithm::MasterMind::Random>, for instance.


=head1 INTERFACE 

=head2 new ( $options )

Normally to be called from derived classes

=head2 add_rule( $combination, $result)

Adds a rule (set of combination and its result as a hash) to the set
of rules. These rules represent the information we've got on the
secret code. 

=head2 check_combination( $secret_code, $combination )

Checks a combination against the secret code, returning a hashref with
the number of blacks (correct in position) and whites (correct in
color, not position)

=head2 check_rule ($rule, $combination) 

Same as C<check_combination>, except that a rule contains a
combination and how it scored against the secret code

=head2 issue_first ()

Issues the first combination, which might be generated in a particular
way 

=head2 issue_next()

Issues the next combination

=head2 feedback()

Obtain the result to the last combination played

=head2 guesses()

Total number of guesses

=head2 evaluated()

Total number of combinations checked to issue result

=head2 number_of_rules ()

Returns the number of rules in the algorithm

=head2 rules()

Returns the rules (combinations, blacks, whites played so far) y a
reference to array

=head2 matches( $string ) 

Returns a hash with the number of matches, and whether it matches
every rule with the number of blacks and whites it obtains with each
of them

=head2 hashify ( $string )

Turns a string into a hash, to help with comparisons. Used internally,
mainly.

=head2 not_in_combination( $string)

Returns the letters from the alphabet that are _not_ in this
combination. Might be useful for certain strategies.

=head2 random_combination

Combines randomly the alphabet, issuing, you guessed it, a random
combination. 


=head1 CONFIGURATION AND ENVIRONMENT

Algorithm::MasterMind requires no configuration files or environment variables.


=head1 DEPENDENCIES

L<Algorithm::Evolutionary>, but only for one of the strategies.


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
