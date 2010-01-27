package Algorithm::MasterMind::EvoRank;

use warnings;
use strict;
use Carp;

use lib qw(../../lib ../../../../Algorithm-Evolutionary/lib/ 
	   ../../Algorithm-Evolutionary/lib/
	   ../../../lib);

our $VERSION =   sprintf "%d.%03d", q$Revision: 1.4 $ =~ /(\d+)\.(\d+)/g; 

use base 'Algorithm::MasterMind::Evolutionary_Base';

use Algorithm::MasterMind qw(partitions);

use Algorithm::Evolutionary qw(Op::QuadXOver
			       Op::String_Mutation
			       Op::Permutation
			       Op::Crossover
			       Op::Canonical_GA_NN
			       Individual::String );

# ---------------------------------------------------------------------------
my $max_number_of_consistent = 20;   # The 20 was computed in NICSO paper, valid for normal mastermind

sub initialize {
  my $self = shift;
  my $options = shift;
  for my $o ( keys %$options ) {
    $self->{"_$o"} = $options->{$o};
  }

  # Variation operators
  my $m = new Algorithm::Evolutionary::Op::String_Mutation; # Rate = 1
  my $c = Algorithm::Evolutionary::Op::QuadXOver->new( 1,2 ); 

  my $fitness = sub { $self->fitness_orig(@_) };
  my $ga = new Algorithm::Evolutionary::Op::Canonical_GA_NN( $options->{'replacement_rate'},
							     [ $m, $c] );
  $self->{'_fitness'} = $fitness;
  $self->{'_ga'} = $ga;

}

sub compute_fitness {
  my $pop = shift;
  #Compute min
  my $min_distance = 0;
  for my $p ( @$pop ) {
    $min_distance = ( $p->{'_distance'} < $min_distance )?
      $p->{'_distance'}:
	$min_distance;
  }

  for my $p ( @$pop ) {
    $p->Fitness( $p->{'_distance'}+
		 ($p->{'_partitions'}?$p->{'_partitions'}:0)-
		 $min_distance + 1);
  }
}

sub issue_next {
  my $self = shift;
  my $rules =  $self->number_of_rules();
  my @alphabet = @{$self->{'_alphabet'}};
  my $length = $self->{'_length'};
  my $pop = $self->{'_pop'};
  my $ga = $self->{'_ga'};

#  print "Rules ", $rules, "\n";
  #Recalculate distances, new game
  my (%consistent );
  for my $p ( @$pop ) {
    ($p->{'_distance'}, $p->{'_matches'}) = @{$self->distance( $p->{'_str'} )};
     $consistent{$p->{'_str'}} = $p if ($p->{'_matches'} == $rules);
  }

  my $number_of_consistent = keys %consistent;
  if ( $number_of_consistent > 1 ) {
    my $partitions = partitions( keys %consistent );      
    for my $c ( keys %$partitions ) {
      $consistent{$c}->{'_partitions'} = scalar (keys  %{$partitions->{$c}});
    }
  }
  my $generations_equal = 0;
  my $this_number_of_consistent = $number_of_consistent;
  
  while ( $this_number_of_consistent < $max_number_of_consistent ) {  

      
    #Compute fitness
    compute_fitness( $pop );
    #      print join( " - ", map( $_->{'_fitness'}, @$pop )), "\n";
    
    #Apply GA
    $ga->apply( $pop );
    
    #Compute new distances
    %consistent = ();  # Empty to avoid problems
    for my $p ( @$pop ) {
      ($p->{'_distance'}, $p->{'_matches'}) = @{$self->distance( $p->{'_str'} )};
      if ($p->{'_matches'} == $rules) {
	$consistent{$p->{'_str'}} = $p;
	#	print $p->{'_str'}, " -> ", $p->{'_distance'}, " - ";
      } else {
	$p->{'_partitions'} = 0;
      }
    }
    
    #Check termination again, and reset
    if ($generations_equal == 50 ) {
      $ga->reset( $pop );
      for my $p ( @$pop ) {
	($p->{'_distance'}, $p->{'_matches'}) = @{$self->distance( $p->{'_str'} )};
      }
      $generations_equal = 0;
    }

#     print "Consistent - => ", join( " - ", 
# 				    map( "* $_ - ".$consistent{$_}->{'_matches'}, 
# 					 sort keys %consistent ) ), "\n\n"; 
    #Check termination conditions
    $this_number_of_consistent =  keys %consistent;
    if ( $this_number_of_consistent == $number_of_consistent ) {
      $generations_equal++;
    } else {
      $generations_equal = 0;
      $number_of_consistent = $this_number_of_consistent;
      # Compute number of partitions
      if ( $number_of_consistent > 1 ) {
	my $partitions = partitions( keys %consistent );      
	for my $c ( keys %$partitions ) {
	  $consistent{$c}->{'_partitions'} = scalar (keys  %{$partitions->{$c}});
	}
      }
    }
    last if ( $generations_equal >= 3 ) && ( $this_number_of_consistent >= 1 ) ;
    #    print "G $generations_equal $this_number_of_consistent \n";
  }
  
  $self->{'_consistent'} = \%consistent; #This mainly for outside info
  #  print "After GA combinations ", join( " ", keys %consistent ), "\n";
#  print "Consistent + => ", join( "-", sort keys %consistent ), "\n\n"; 
  if ( $this_number_of_consistent > 1 ) {
    #    print "Consistent ", scalar keys %consistent, "\n";
    #Use whatever we've got to compute number of partitions
    my $partitions = partitions( keys %consistent );
    
    my $max_partitions = 0;
    my %max_c;
    for my $c ( keys %$partitions ) {
      my $this_max =  keys %{$partitions->{$c}};
      $max_c{$c} = $this_max;
      if ( $this_max > $max_partitions ) {
	$max_partitions = $this_max;
      }
    }
    # Find all partitions with that max
    my @max_c = grep( $max_c{$_} == $max_partitions, keys %max_c );
    # Break ties
    my $string = $max_c[ rand( @max_c )];
    # Obtain next
    return  $self->{'_last'} = $string;
  } else {
    return $self->{'_last'} = (keys %consistent)[0];
  }
  
}

"some blacks, 0 white"; # Magic true value required at end of module

__END__

=head1 NAME

Algorithm::MasterMind::EvoRank - Evolutionary algorith with the
partition method and ranked fitness, prepared for GECCO 2010 


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
