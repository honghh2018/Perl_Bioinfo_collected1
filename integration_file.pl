#!/usr/bin/perl -w
use strict;
use warnings;

open(IN,"$ARGV[0]") or die "$!";
open(IN1,"$ARGV[1]") or die "$!";
open(OUT,">$ARGV[2]");

my %transcripts=();
while(<IN>){
	chomp;
	my ($tran_id,$left)=split /\||\s+/,$_,2;
	$transcripts{$tran_id}=$left;
}
while(<IN1>){
	chomp;
	if(/transcript/){
		my ($gene_id,$stran_id)=(split /\s+/,$_)[9,11];
		$gene_id =~s/^\"|\"\;$//g;$stran_id=~s/^\"|\"\;$//g;
		if(exists $transcripts{$stran_id}){
			if($transcripts{$stran_id} =~/\([-+]\)\|/){
				 my ($second_col,$third_col)=split /\s+/,$transcripts{$stran_id},2;
				 print OUT $stran_id,"|",$second_col,"\t",$gene_id,"\t",$third_col,"\n";
			}else{
				print OUT $stran_id,"\t",$gene_id,"\t",$transcripts{$stran_id},"\n";
			}
			
		}
	}else{
		next;
	}
}


close IN;
close IN1;
close OUT;
