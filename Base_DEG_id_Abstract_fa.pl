#!/usr/bin/perl -w
use strict;
use warnings;
use File::Basename;

open(IN,"$ARGV[0]") or die $!;
open(IN1,"$ARGV[1]") or die $!;
my $outfilename=basename($ARGV[1]);
open(OUT,">$outfilename"."_result");

my %deg=();
$/=">";
while(<IN>){
        chomp;
        next if(/^$/);
        my($gene_id,$seq)=split /\n/,$_,2;
        $deg{$gene_id}=$seq;    
}
close IN;
$/="\n";
while(<IN1>){
        chomp;
        my $gene_id=(split /\s+/,$_)[0];
        if(exists $deg{$gene_id}){
                print OUT ">",$gene_id,"\n";
                print OUT $deg{$gene_id};
        }

}
close IN1;
close OUT;
