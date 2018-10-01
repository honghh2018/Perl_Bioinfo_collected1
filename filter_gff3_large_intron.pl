#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Std; #Even though getopts out of shell but it need the module Getopt::Std
my %options;
getopts("i:o:T:",\%options); #The getopts function given by shell no perl,which was a parameter captured on command line.
#Conditional judgement
if(!defined $options{i} ||!defined $options{o} ||!defined $options{T}){
        my $usage=qq'
        USAGE:
        Contact:honghh\@biomarker.com.cn
        perl $0 -i <inputfile> -o <outputfile> -T <Threshold> :T <integer>
        comments:Threshold default =1000000
';
        print $usage;
        exit;
}
#Program start:
$options{T} ||=1000000;
open(IN,"$options{i}");
open(OUT,">$options{o}");

my $lastid; #
my $flag; #flag mark
while(<IN>){
        chomp;
        next if(/\#/); #match # skip　loop
        $flag=0;
        if(/gene/){
                my @field=split /\t/,$_;
                my @lastid_sep=split /\;/,$field[-1];
                #print OUT1 $lastid_sep[0],"\n";
                if(abs($field[4]-$field[3]) > $options{T}){
                        $flag=1;
                        $lastid=$lastid_sep[0];
                }
        }
        if($flag==1 || $_=~/$lastid/){
                next;
        }
                print OUT $_,"\n";
}
close IN;
close OUT;
#close OUT1;

