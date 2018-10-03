#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;　　＃getopts　given by module of Getopt::Std,so when using getopts,the Getopt::Std must be loaded 

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
open(OUT1,">filter_id_2018.txt");

##filter file header of gff3
while(<IN>){
        chomp;
        if($_=~/^\w+/){
                last;
        }else{
                print OUT $_,"\n";
        }
}

$/="###\n";
my $count=0;
while(<IN>){
        chomp;
        next if(/^.*$/);
        if($_=~/\+.*\-/sm || $_=~/\-.*\+/sm){
                my $gene_id=(split /\;/,(split /\s+/,(split /\n+/,$_,2)[0])[-1])[0];
                $count++;
                print OUT1 $gene_id,"\n";
        }else{
                print OUT $_,"###","\n";
        }
   }
print OUT1 "Number of gene on both positive strand and negative strand:",$count,"\n";
$/="\n";
close IN;
close OUT;
close OUT1;
     
        
        
        
        
