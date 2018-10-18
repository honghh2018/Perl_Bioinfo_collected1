#!/usr/bin/perl
use strict;
use warnings;

open(IN,"$ARGV[0]") or die $!;
open(IN1,"$ARGV[1]") or die $!;
open(OUT,">$ARGV[2]");

my %tran=();
$/=">";
while(<IN>){
        chomp;
        next if(/^$/);
        my($gene_id,$seq)=split /\n/,$_;
        $tran{$gene_id}=$seq;
}

close IN;

while(<IN1>){
        chomp;
        next if(/^$/);
        my $gene_id=(split /\n/,$_)[0];
        if(exists $tran{$gene_id}){
                print OUT ">",$gene_id,"\n";
                print OUT $tran{$gene_id},"\n";
        }else{
                print OUT ">",$_;
        }


}
$/="\n";
close IN1;
close OUT;

