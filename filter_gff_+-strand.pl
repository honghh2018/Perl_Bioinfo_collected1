#!/usr/bin/perl 
use strict;
use warnings;
use Getopt::Std;



my %para;
getopts('a:i:o:b:c:d:e:f:h:i:j:k:l:m:n:',\%para);

if(!defined $para{i} || !defined $para{o}){
        my $usage=qq'
        Usage:
        Contact:honghh\@honghh.com.cn
        perl $0 -i <infile> -o <outfile>
';
        print $usage;
        exit;
}

open(IN,"$para{i}") or die "$!";
open(OUT,">$para{o}");

my %gene_hash=();
my $last_id="";
while(<IN>){
        chomp;
        if($_ =~/gene/){
                $last_id=(split /\;/,(split /\s+/,$_)[-1])[0];
                push @{$gene_hash{$last_id}},$_;
        }else{
                push @{$gene_hash{$last_id}},$_;                
        }
}

my @strand=();
for my $key(sort keys %gene_hash){
        for my $i(0..$#{$gene_hash{$key}}){
                push @strand,(split /\s+/,${$gene_hash{$key}}[$i])[6];
        }
        my $flag=&diff(\@strand);
        if($flag ==1){
                for my $i(0..$#{$gene_hash{$key}})
                {
                        print OUT ${$gene_hash{$key}}[$i],"\n";
                }
        }else{
                next;
        }
}

close IN;
close OUT;

sub diff{
        my $refar=shift;
        my $symbol=shift(@{$refar});
        while(<@{$refar}>){
                if($symbol eq $_){
                        $symbol=$_;
                }else{
                        return 0;
                }
        }
        return 1;
}



