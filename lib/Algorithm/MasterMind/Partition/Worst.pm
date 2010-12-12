package Algorithm::MasterMind::Partition::Worst;

use warnings;
use strict;
use Carp;

use lib qw(../../lib ../../../lib ../../../../lib);

our $VERSION =   sprintf "%d.%03d", q$Revision: 1.1 $ =~ /(\d+)\.(\d+)/g; 

use base 'Algorithm::MasterMind::Partition';

use Algorithm::MasterMind qw( partitions );

sub compute_next_string {
  my $self = shift;
  my $partitions = shift || croak "No partitions";
    
  # Obtain best
  my %min_c;
  my $min_max = keys %$partitions ;
  for my $c ( keys %$partitions ) {
    my $this_max = 0;
    for my $p ( keys %{$partitions->{$c}} ) {
      if ( $partitions->{$c}{$p} > $this_max ) {
	$this_max = $partitions->{$c}{$p};
      }
    }
    $min_c{ $c } = $this_max;
    if ( $this_max < $min_max ) {
      $min_max = $this_max;
    }
  }
    
  # Find all partitions with that max
  my @minimal_c = grep( $min_c{$_} == $min_max, keys %min_c );
    
  # Break ties
  return $minimal_c[ rand( @minimal_c )];
}

"while some were blacks, the sun was shining"; # Magic true value required at end of module

__END__

=head1 NAME

Algorithm::MasterMind::Partition::Worst - Plays by Knuth's playbook


=head1 SYNOPSIS

    use Algorithm::MasterMind::Partition::Worst;
    my $secret_code = 'EAFC';
    my @alphabet = qw( A B C D E F );
    my $solver = new Algorithm::MasterMind::Partition::Worst { alphabet => \@alphabet,
						   length => length( $secret_code ) };

  
=head1 DESCRIPTION

Solves the algorithm by issuing each time a combination with a
particular score; the computation of that score is delegated to
subclasses. 

=head1 INTERFACE 

=head2 compute_next_string 

Computes the string with the best worst case number of elements in partitions. 

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
