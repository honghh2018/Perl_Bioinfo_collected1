#!/usr/bin/perl -w
use strict;

open(IN,"$ARGV[0]") or die $!;
$/=">";
my %fa=();
while(<IN>){
        chomp;
        next if(/^$/);
        my($gene_id,$seq)=split /\n/,$_,2;
        my $real=(split /\t/,$gene_id)[0];
        $seq=~s/\n//g;
        $fa{$real}=$seq;
}
close IN;
$/="\n";
open(IN,"$ARGV[1]") or die $!;
open(OUT,">result.txt");
$\="\n"; ##output file format that means newline
$,="\t"; ##ouput file format that means tab seperate
while(<IN>){
        chomp;
        my ($gene_id,$rest)=(split /\s+/,$_,3)[0,1];
        if($.==1){
                print OUT $gene_id,$rest;
                next;
        }
        if(exists $fa{$gene_id}){
                print OUT $gene_id,$rest;
        }

}
close IN;
close OUT;
