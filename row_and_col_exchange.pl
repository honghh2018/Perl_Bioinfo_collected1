#!/usr/bin/perl -w
use strict;
use warnings;

open(IN,"$ARGV[0]") or die $!;
open(OUT,">$ARGV[1]");

my @array=<IN>;
my @dimension=();
my $lastcol=0;
for my $row(0..$#array){
  my @tmp=split(/\s+/,$array[$row]);
  $lastcol=@tmp;
  for my $col(0..$#tmp){
  	$dimension[$row][$col]=$tmp[$col];
  }
}

close IN;

#transfer
for my $row(0..$lastcol-1){
	for my $col(0..$#array){
		print OUT $dimension[$col][$row],"\t";
	}
	print OUT "\n";
}


close OUT;
