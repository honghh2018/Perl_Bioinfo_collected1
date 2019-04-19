#!/usr/bin/perl -w
use strict;
use autodie;

open(IN,$ARGV[0]);
my $count1=0;
while(<IN>){
        chomp;
        if($.==1){
                print $_,"\n";
                next;
        }
        my @temp=split /\s+/,$_;
        shift@temp;
        my $count=0;
        for(my $i=0;$i<scalar @temp;$i++){
                if($temp[$i]==0){
                        $count++;
                }
        }
        if($count >= 1){
                $count1++;
                next;
        }
        print $_,"\n";

}
close IN;
print STDERR "filter num:".$count1."\n";
=pod head
perl $0 fpkm_file >result.list
