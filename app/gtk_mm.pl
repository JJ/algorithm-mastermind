#!/usr/bin/perl

use strict;
use warnings;

use lib qw(../lib ../../Algorithm-Evolutionary/lib ../../lib);

use Gtk2 '-init';
use Gtk2::GladeXML;
use Glib qw/TRUE FALSE/;
use Algorithm::MasterMind qw( check_combination );
use Algorithm::MasterMind::Evo;

my $programa = Gtk2::GladeXML->new('Entry.glade');
my %allocated_colors;

my $ventana_principal = $programa->get_widget('window1');
my $colors_widget = $programa->get_widget('VColors');
my $length_widget = $programa->get_widget('VLen');
my $secret_widget = $programa->get_widget('secret');
my $etiqueta = $programa->get_widget('label2');
my $gaming_widget = $programa->get_widget('gaming_area');
#$gaming_widget->modify_bg('normal',Gtk2::Gdk::Color->new (0xc0c0,0x5858,0x0) );
$programa->signal_autoconnect_from_package('main');
$etiqueta->set_markup( "Nothing yet" );
$ventana_principal->show_all();

Gtk2->main;

sub on_quit_clicked {
    Gtk2->main_quit;
}

sub on_run_clicked {

  my $colors = $colors_widget->get_active_text();
  my $length = $length_widget->get_active_text();
  my $secret_code =  substr($secret_widget->get_text(),0,$length);
  print "Colors $colors length $length\n";
  $etiqueta->set_markup( "<b>$colors $length</b> $secret_code" );

  my $colormap = $gaming_widget->window->get_colormap;
  my $gc = $gaming_widget->{'gc'} || new Gtk2::Gdk::GC $gaming_widget->window;
  $gc->set_foreground(get_color($colormap, 'brown'));
  $gaming_widget->window->draw_rectangle($gc,TRUE,
   				 0, 0, 
   				 $gaming_widget->allocation->width,
   				 $gaming_widget->allocation->height );
  my @alphabet = ('A'..'Z')[0..($colors-1)];
  
  my $method_options = { consistent_set_card =>  10,
			 replacement_rate =>  0.75,
			 xover_rate =>  8,
			 permutation_rate =>  1,
			 tournament_size =>  7,
			 length => $length,
			 alphabet => \@alphabet,
			 pop_size => 200+($length-4)*200
		       };
  my $solver = new Algorithm::MasterMind::Evo $method_options;

  my $game = { code => $secret_code,
	       combinations => []};
  my $first_string = $solver->issue_first;
  my $response =  check_combination( $secret_code, $first_string);
  push @{$game->{'combinations'}}, [$first_string,$response] ;
  my $diameter = 30;
  my $padding = 5;
  draw_move( $gc, $colormap, 20, $first_string, $response, $diameter, $padding );
  $solver->feedback( $response );
  my $played_string = $solver->issue_next;
  my $line = 1;

  while ( $played_string ne $secret_code ) {
    $response = check_combination( $secret_code, $played_string);
    draw_move( $gc, $colormap, 20+($diameter+$padding)*$line, $played_string, $response, $diameter, $padding ); 
    push @{$game->{'combinations'}}, [$played_string, $response] ;
    $solver->feedback( $response );
    $played_string = $solver->issue_next;
    $line++;
  }
  draw_move( $gc, $colormap, 20+($diameter+$padding)*$line, $played_string, 
	     { blacks => $length, whites => 0 }, $diameter, $padding );
  $game->{'evaluations'} = $solver->evaluated();
  $etiqueta->set_markup( "Found <b>" .  $game->{'evaluations'} . "</b> Evaluations " );
}

sub draw_move {
  my $gc = shift;
  my $colormap = shift;
  my $base_y = shift;
  my $move = shift;
  my $response = shift;
  my $diameter = shift;
  my $padding = shift;
  my @colors = qw(red green blue yellow orange gray maroon pink);
  my @these_colors = map( ord($_) - ord('A'), split(//,$move) );
  my $startx=20;
#  print "Response ". $response->{'blacks'} . " " . $response->{'whites'}, "\n";
  for ( my $i = 0; $i <= $#these_colors; $i++) {
    $gc->set_foreground(get_color($colormap, $colors[$these_colors[$i]]));
    $gaming_widget->window->draw_arc($gc,1, 
				     $startx +$i*($diameter+$padding), $base_y, 
				     $diameter, $diameter,
				     0, 360*64 );
  }
  my $blacks = $response->{'blacks'};
  my $whites = $response->{'whites'};
  my $j;
  $gc->set_foreground(get_color($colormap, 'black'));
  my $base_x = $startx +$padding*2 + @these_colors*($diameter+$padding);
  for ( $j = 0; $j < $blacks; $j ++ ) {
     $gaming_widget->window->draw_arc($gc,1, 
				      $base_x +$j*($diameter+$padding)/2, $base_y, 
				     $diameter/2, $diameter/2,
				     0, 360*64 );
  }
  $gc->set_foreground(get_color($colormap, 'white'));
  $base_x = $startx + $padding*2 + @these_colors*($diameter+$padding)+$j*($diameter+$padding)/2;
  for ( $j = 0; $j < $whites; $j ++ ) {
    $gaming_widget->window->draw_arc($gc,1, 
				     $base_x +$j*($diameter+$padding)/2, $base_y, 
				     $diameter/2, $diameter/2,
				     0, 360*64 );
  }
}

###########################################
sub get_color {
    my ($colormap, $name) = @_;
    my $ret;

    if ($ret = $allocated_colors{$name}) {
        return $ret;
    }

    my $color = Gtk2::Gdk::Color->parse($name);
    $colormap->alloc_color($color,TRUE,TRUE);

    $allocated_colors{$name} = $color;

    return $color;
}
