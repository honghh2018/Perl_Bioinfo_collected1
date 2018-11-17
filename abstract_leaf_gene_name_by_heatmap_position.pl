#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
open(IN1,"$ARGV[0]") or die "$!";
my $basename=basename($ARGV[0]);
open(OUT,">position_dir_abstract/$basename");

while(<IN1>){
	chomp;
	if(/leaf/){
		my $gene_id=(split /\"/)[1];
		print OUT $gene_id,"\n";
	}
}

close IN1;close OUT;
