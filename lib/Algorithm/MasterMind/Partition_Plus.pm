package Algorithm::MasterMind::Partition_Plus;

use warnings;
use strict;
use Carp;

use lib qw(../../lib ../../../lib);

our $VERSION =   sprintf "%d.%03d", q$Revision: 1.1 $ =~ /(\d+)\.(\d+)/g; 

use parent 'Algorithm::MasterMind::Partition_Entropy';

sub initialize {
  my $self = shift;
  my $options = shift;
  for my $o ( keys %$options ) {
    $self->{"_$o"} = $options->{$o};
  }
  $self->{'_partitions'} = {};
}

sub issue_first {
   my $self = shift;
   $self->{'_first'} = 1; # Flag for next
   return $self->{'_last'} = $self->issue_first_Knuth();
}

sub intersection { 
  my ($arrayref1, $arrayref2 ) = @_;
  my %count;  #taken from perlmonks http://www.perlmonks.org/?node_id=893476
  foreach my $a (@$arrayref1, @$arrayref2) {
    $count{$a}++; 
  }
  return grep( $count{$_} > 1, keys %count);

}
sub issue_next {
  my $self = shift;
  my $last_rule = $self->{'_rules'}->[scalar(@{$self->{'_rules'}})-1];
  if ( $self->{'_first'} ) {
    my @combinations = $self->all_combinations();
    $self->{'_partitions'} = 
      Algorithm::MasterMind::Consistent_Set->create_consistent_with( \@combinations, $self->{'_rules'} );
    $self->{'_evaluated'} = scalar( @{$self->{'_partitions'}->{'_combinations'}}  );
    delete $self->{'_first'};
  } else {
    $self->{'_partitions'}->cull_inconsistent_with( $last_rule->{'combination'}, $last_rule );
  }
  if ( @{$self->{'_partitions'}->{'_combinations'}} > 1 ) {
    $self->{'_partitions'}->compute_entropy_score;
    my @top_scorers_e = $self->{'_partitions'}->top_scorers('entropy');
    $self->{'_partitions'}->compute_most_score;
    my @top_scorers_m = $self->{'_partitions'}->top_scorers('most');
    my @all_top = intersection( \@top_scorers_e, \@top_scorers_m );
    if ( !@all_top ) {
      @all_top = @top_scorers_m;
      push @all_top, @top_scorers_e;
    }
    return $self->{'_last'} = $all_top[ rand(@all_top)];
  } else {
    return $self->{'_last'} = $self->{'_partitions'}->{'_combinations'}->[0]->string;
  }
}

"some blacks, 0 white"; # Magic true value required at end of module

__END__

=head1 NAME

Algorithm::MasterMind::Partition_Combined - Combine entropy and most


=head1 SYNOPSIS

    use Algorithm::MasterMind::Partition_Worst;
    my $secret_code = 'EAFC';
    my @alphabet = qw( A B C D E F );
    my $solver = new Algorithm::MasterMind::Partition_Worst { alphabet => \@alphabet,
						   length => length( $secret_code ) };

  
=head1 DESCRIPTION

Exactly the same as L<Algorithm::MasterMind::Partition_Most>, except
that it issues a fixed first move in the same way Knuth does. 

=head1 INTERFACE 

=head2 initialize()

Called from C<new>, initializes data structures.

=head2 issue_first ()

Issues it in the Knuth way, AABC. This should probably be computed
from scratch (to be coherent with the algorithm), but it's already
    published, so what the hell. 

=head2 issue_next()

Issues the next combination

=head1 AUTHOR

JJ Merelo  C<< <jj@merelo.net> >>, and obviously, Donald Knuth as
    author of the algorithm.


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
