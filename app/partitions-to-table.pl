#!/usr/bin/perl

use YAML qw(LoadFile);

my $file_name = $_ || "partitions.yaml";

my $partitions = LoadFile( $file_name) || die "Can't read file $file_name for $@\n";

my %keys;
for my $p ( keys %$partitions ) {
    for my $k ( keys %{$partitions->{$p}} ) {
	$keys{$k} = 1;
    }
}

my @keys = sort keys %keys;
print " \&", join( "& ", @keys ) , "\n";
my $last_key = $keys[$#keys];

for my $p (sort keys %$partitions ) {
  print "$p \&";
  for my $k ( @keys ) {
    print $partitions->{$p}->{$k} || 0 ;
    if ($k eq $last_key) {
      print " \\\\ \n";
    } else {
      print ' & ';
    }
  }
}
