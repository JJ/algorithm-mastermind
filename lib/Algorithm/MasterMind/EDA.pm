package Algorithm::MasterMind::EDA;

use warnings;
use strict;
use Carp;

use lib qw(../../lib 
	   ../../../../Algorithm-Evolutionary/lib
	   ../../../Algorithm-Evolutionary/lib
	   ../../Algorithm-Evolutionary/lib);

our $VERSION =   sprintf "%d.%03d", q$Revision: 1.5 $ =~ /(\d+)\.(\d+)/g; 

use base 'Algorithm::MasterMind';

use Algorithm::Evolutionary qw( Individual::BitString
				Op::EDA_step );

sub fitness {
    my $self = shift;
    my $object = shift;
    my $combination = $object->{'_str'};
    my $matches = $self->matches( $combination );

    my $blacks_and_whites = 1;
    for my $r (@{$matches->{'result'}} ) {
	$blacks_and_whites += $r->{'blacks'} + $r->{'whites'}+ $self->{'_length'}*$r->{'match'};
    }
    return $blacks_and_whites;
      
}

sub fitness_orig {
  my $self = shift;
  my $object = shift;
  my $combination = $object->{'_str'};
  my $matches = $self->matches( $combination );

  my $fitness = 1;
  my @rules = @{$self->{'_rules'}};
  for ( my $r = 0; $r <= $#rules; $r++) {
    $fitness += abs( $rules[$r]->{'blacks'} - $matches->{'result'}->[$r]->{'blacks'} ) +
      abs( $rules[$r]->{'whites'} - $matches->{'result'}->[$r]->{'whites'} );
  }
  return 1/$fitness;
}

sub initialize {
  my $self = shift;
  my $options = shift;
  for my $o ( keys %$options ) {
    $self->{"_$o"} = $options->{$o};
  }

  my $length = $options->{'length'}; 

#----------------------------------------------------------#
#
  my $fitness;
  if ( $self->{'_orig'} ) {
    $fitness = sub { $self->fitness_orig(@_) };
  } else {
    $fitness = sub { $self->fitness(@_) };
  }

#EDA itself
  my $eda = new Algorithm::Evolutionary::Op::EDA_step( $fitness, 
						       $options->{'replacement_rate'},
						       $options->{'pop_size'},
						       $self->{'_alphabet'});
  $self->{'_fitness'} = $fitness;
  $self->{'_eda'} = $eda;

  
}

sub issue_first {
  my $self = shift;
  my $string;
  my @alphabet = @{ $self->{'_alphabet'}};
  my $half = @alphabet/2;
  for ( my $i = 0; $i < $self->{'_length'}; $i ++ ) {
    $string .= $alphabet[ $i % $half ]; # Recommendation Knuth
  }
  $self->{'_first'} = 1; # Flag to know when the second is due

  #Initialize population for next step
  my @pop;
  for ( 0..$self->{'_pop_size'} ) {
    my $indi = Algorithm::Evolutionary::Individual::String->new( $self->{'_alphabet'}, 
								 $self->{'_length'} );
    push( @pop, $indi );
  }
  
  $self->{'_pop'}= \@pop;
  
  return $self->{'_last'} = $string;
}

sub issue_next {
  my $self = shift;
  my $rules =  $self->number_of_rules();
  my ($match, $best);
  my $pop = $self->{'_pop'};
  my $eda = $self->{'_eda'};

  map( $_->evaluate( $self->{'_fitness'}), @$pop );
  my @ranked_pop = sort { $b->{_fitness} <=> $a->{_fitness}; } @$pop;
  if ( $ranked_pop[0]->Fitness() == 1 ) { #Already found!
    return  $self->{'_last'} = $ranked_pop[0]->{'_str'};
  } else {
    my $generations_passed = 0;
    do {
      $eda->apply( $pop );
      $best = $pop->[0];
      $match = $self->matches( $best->{'_str'} );
      $generations_passed ++;
      if ($generations_passed == 15 ) {
	$eda->reset( $pop );
	$generations_passed = 0;
      }
    } while ( $match->{'matches'} < $rules );
    return  $self->{'_last'} = $best->{'_str'};
  }

}

"Many blacks, 0 white"; # Magic true value required at end of module

__END__

=head1 NAME

Algorithm::MasterMind::Evolutionary - Tries to compute new solution from last


=head1 SYNOPSIS

    use Algorithm::MasterMind::Evolutionary;

  
=head1 DESCRIPTION

Mainly used in test functions, and as a way of instantiating base
class. 


=head1 INTERFACE 

=head2 initialize()

Does nothing, really

=head2 new ( $options )

This function, and all the rest, are directly inherited from base

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

=head2 fitness( $individual )

Computes fitness summing the number of correct black and whites plus
the number of rules the combination meets times the length

=head2 fitness_orig( $individual )

Fitness proposed in the Applied and Soft Computing paper, difference
between the number of blacks/whites obtained by rules against the
secret code and by the combination against the combination in the
rule. 


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