#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/proyectos/CPAN/Algorithm_Mastermind/lib
    /home/jmerelo/proyectos/CPAN/Algorithm-Evolutionary/lib
	 ..);
    							    
use CGI qw(:standard :form);

use Algorithm::MasterMind qw(check_combination);
use Algorithm::MasterMind::EDA;

print header();

if ( param('code' ) ) {
  solve( param('code') );
} else {
  show_form();
}
print end_html;

sub show_form {
    print start_html( 'MM solver using EDAs' ),
      h1('Mastermind input form'),
      p('This program tries to find a code (composed of four letters in the set A..F) using an estimation of distributiona algorithm. Please enter any combination, and wait for the result!');
    form();
    
}

sub form {
  print
   start_form,	
     p("Combination to find e.g. ACDE "),
       textfield(-name => 'code',
		 -default => 'ACEF',
		 -size=> 4),
		   end_form;
}

sub solve {
    my $code = shift;
    #Clean up
    $code = uc( $code );
    $code = substr( $code, 0, 4);
    $code =~ s/[^A-F]/A/g;
    if ( length( $code ) < 4 ) {
      do {
	$code .= 'A';
      } until (length( $code ) == 4);
    }
    my @alphabet = qw( A B C D E F );
    my $solver = new Algorithm::MasterMind::EDA { alphabet => \@alphabet,
						    length => length( $code ),
						      pop_size => 300};
    
    print start_html("Trying to find the solution for $code"),
      h1("Seeking $code");
    
    my $first_string = $solver->issue_first;
    my $response =  check_combination( $code, $first_string);
    print p(print_combination($first_string,$response)), "\n";

    $solver->feedback( $response );
    
    my $played_string = $solver->issue_next;
    while ( $played_string ne $code ) {
      $response = check_combination( $code, $played_string);
      $solver->feedback( $response );
      print p(print_combination($played_string, $response )), "\n";
      $played_string = $solver->issue_next;      
    }  
    print p( "Found code after ".$solver->evaluated()." combinations. " ),
      h2("Play again?");
    form();
    
}

sub print_combination {
  my ($combination, $response ) = @_;
  return strong($combination)." - ".em(($response->{'blacks'}?($response->{'blacks'}." black(s)"):"").
			     ($response->{'whites'}?(" ".$response->{'whites'}." white(s)"):"") );

}
