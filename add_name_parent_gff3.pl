#!/usr/bin/perl
use strict;
use warnings;

open(IN,"$ARGV[0]") or die "$!";
open(OUT,">$ARGV[1]");
#open(OUT1,">$ARGV[2]");
my $count=0;
my $count1=0;
while(<IN>){
        chomp;
        if(/^\#/){
                print OUT $_,"\n";
                next;
        }
                
        if($_ =~/gene/){
                $count=split /\;/,(split /\t/,$_)[-1];
                if($count == 1){
                        my $id=(split /\=/,(split /\t/,$_)[-1])[1];
                        print OUT $_,";","Name=$id","\n";
                        next;
                }
                        #my $id_1=(split /\;/,(split /\t/,$_)[-1])[0];
                        #print OUT1 $id_1,"\n";
                }
        if($_ =~/mRNA/){
                $count1=split /\;/,(split /\t/,$_)[-1];
                if($count1==1){
                    my $id=(split /\=/,(split /\t/,$_)[-1])[1];
                    print OUT $_,";","Parent=$id","\n";
                    next;
                }
        
        }
        print OUT $_,"\n";
                
}
        


close IN;
close OUT;
#close OUT1;
