#!/usr/bin/perl -w
use strict;
use warnings;

open(IN,"$ARGV[0]") or die $!;
open(OUT,">$ARGV[1]");

while(<IN>){
chomp;
$_=~s/\,|\s+|\:|\_|\||\.|\-|\;/\t/g;
print OUT $_,"\n";
}

close IN;
close OUT;
