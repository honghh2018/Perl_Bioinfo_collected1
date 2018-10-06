#!/usr/bin/perl 
use strict;
use warnings;

open(IN,"$ARGV[0]") or die "$!";
open(OUT,">$ARGV[1]");
#filter seq where no "gene" marker given
my $flag=0;
my $last_id=0;

while(<IN>){
	chomp;
	if(/^\#/){
	print OUT $_,"\n";
	next;
	}

	if($_ =~/gene/){
		$flag=1;
		$last_id=(split /\;/,(split /\t/,$_)[-1])[0];
	}else{
		$flag=0;
	}
	if($flag==1 or $_ =~/$last_id/){
		print OUT $_,"\n";	
	}else{
		next;
	}
	
}


close IN;
close OUT;
