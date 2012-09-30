#!/usr/bin/perl

use strict;
use warnings;
use subs qw{ main on_window_destroy };

use Gtk2 '-init';
use Gtk2::GladeXML;
use Glib qw/TRUE FALSE/;

my $programa = Gtk2::GladeXML->new('Entry.glade');
my %allocated_colors;

my $ventana_principal = $programa->get_widget('window1');
my $colors_widget = $programa->get_widget('VColors');
my $length_widget = $programa->get_widget('VLen');
my $secret_widget = $programa->get_widget('secret');
my $etiqueta = $programa->get_widget('label2');
my $gaming_widget = $programa->get_widget('gaming_area');
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
  my $secret =  substr($secret_widget->get_text(),0,$length);
  print "Colors $colors length $length\n";
  $etiqueta->set_markup( "<b>$colors $length</b> $secret" );

  my @colors = qw(red green blue pink orange brown maroon yellow);
  my $colormap = $gaming_widget->window->get_colormap;
    
    my $gc = $gaming_widget->{'gc'} || new Gtk2::Gdk::GC $gaming_widget->window;
    
    my $startx=20;
    my $y = 20;
    my $diameter = 30;
    my $padding = 5;
    for ( my $i = 0; $i < 5; $i++) {
      $gc->set_foreground(get_color($colormap, $colors[rand(@colors)]));
      $gaming_widget->window->draw_arc($gc,1, 
				       $startx +$i*($diameter+$padding), $y, 
				       $diameter, $diameter,
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
