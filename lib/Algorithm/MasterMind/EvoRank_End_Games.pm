package Algorithm::MasterMind::EvoRank_End_Games;

use warnings;
use strict;
use Carp;

use lib qw(../../lib ../../../../Algorithm-Evolutionary/lib/ 
	   ../../Algorithm-Evolutionary/lib/
	   ../../../lib);

our $VERSION =   sprintf "%d.%03d", q$Revision: 1.2 $ =~ /(\d+)\.(\d+)/g; 

use base 'Algorithm::MasterMind::EvoRank';

sub issue_next {
  my $self = shift;
  my @rules =  @{$self->{'_rules'}};
  my @alphabet = @{$self->{'_alphabet'}};
  my $length = $self->{'_length'};
  my $pop = $self->{'_pop'};
  my $ga = $self->{'_ga'};
  my $max_number_of_consistent  = $self->{'_max_consistent'};

  my $last_rule = $rules[$#rules];
  
  #Check for no color
  my $alphabet_size = @{$self->{'_alphabet'}};
  if ($last_rule->{'blacks'}+$last_rule->{'whites'} == 0 ) {
      my %these_colors;
      map ( $these_colors{$_} = 1, split( //, $last_rule->{'combination'} ) );
      for (my $i = 0; $i < @{$self->{'_alphabet'}}; $i++ ) {
	  if ($these_colors{$self->{'_alphabet'}->[$i]} ) {
	      splice( @{$self->{'_alphabet'}},$i,1)  ;
	  }
      }
      $self->realphabet;
      $self->shrink_to( @$pop * @{$self->{'_alphabet'}} / $alphabet_size );
  }

  #Check for colors guessed right
  if ($last_rule->{'blacks'}+$last_rule->{'whites'} == $length ) {
      my %these_colors;
      map ( $these_colors{$_} = 1, split( //, $last_rule->{'combination'} ) );
      @{$self->{'_alphabet'}} = keys %these_colors;
      $self->realphabet;
      $self->shrink_to( @$pop * @{$self->{'_alphabet'}} / $alphabet_size );
  }

  my $to_play = $self->SUPER::issue_next();
  return $to_play;
  
}

"some blacks, 1 white"; # Magic true value required at end of module

__END__

=head1 NAME

Algorithm::MasterMind::EvoRank_End_Games - Adding end_games (tricks) for making a faster exploration of the solutions space


=head1 SYNOPSIS

    use Algorithm::MasterMind::Evolutionary_Partitions;

  
=head1 DESCRIPTION

The partition method was introduced in a 2010 paper, and then changed
by Runarsson and Merelo to incorporate it in the genetic search. It
was prepared for a conference paper.

=head1 INTERFACE 

=head2 initialize

Initializes the genetic part of the algorithm

=head2 issue_next()

Issues the next combination, using this method.

=head2 compute_fitness()

Processes "raw" fitness to assign fitness once consistency and/or
distance to it is known. It's lineally scaled to make the lowes
combination = 1



=head1 AUTHOR

JJ Merelo  C<< <jj@merelo.net> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2009, 2010 JJ Merelo C<< <jj@merelo.net> >>. All rights reserved.

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
