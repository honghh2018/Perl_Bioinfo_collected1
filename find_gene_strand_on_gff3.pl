#!/usr/bin/perl -w
use strict;

open(IN,"$ARGV[0]") or die $!;
my %fa=();

$/=">";
while(<IN>){
        chomp;
        next if(/^$/);
        my($gene_id,$seq)=split /\n/,$_,2;
        $seq =~s/\n//gi;
        $fa{$gene_id}=$seq;
}
close IN;
$/="\n";
open(IN,"$ARGV[1]") or die $!;
my %gff=();
while(<IN>){
        chomp;
        my ($annotation,$strand,$tail)=(split /\s+/,$_)[2,6,-1];
        #print STDERR $strand,"\n";
        if($annotation eq "gene"){
                my $gene_id=(split /\=/,$tail)[1];
                $gff{$gene_id}{$strand}="";
        }
}
close IN;
$,="\t";
$\="\n";
foreach my $key(sort{$a cmp $b}keys %gff){
        if(exists $fa{$key}){
                my ($strand)=keys %{$gff{$key}};
                print ">".$key."\t"."strand:".$strand."\n".$fa{$key};
        }
}

