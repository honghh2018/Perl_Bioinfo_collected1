#!/usr/bin/perl -w
use strict;
use warnings;
use File::Basename;


open(IN,"$ARGV[0]") or die $!;
my $filename=basename($ARGV[0]);
open(OUT,">$filename.result");

print OUT "Gene_id","\t","Transcript_id","\n";
while(<IN>){
	 chomp;
        if(/transcript/){
                my ($gene_id,$tran_id)=(split /\s+/,$_)[9,11];
                $gene_id =~s/^\"|\"\;$//g;$tran_id=~s/^\"|\"\;$//g;
		print OUT $gene_id,"\t",$tran_id,"\n";
	}

}
close IN;
close OUT;
=cut
 chomp;
        if(/transcript/){
                my ($gene_id,$stran_id)=(split /\s+/,$_)[9,11];
                $gene_id =~s/^\"|\"\;$//g;$stran_id=~s/^\"|\"\;$//g;
