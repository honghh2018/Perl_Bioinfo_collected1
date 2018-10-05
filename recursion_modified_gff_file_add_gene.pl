#!/usr/bin/perl -w
use strict;
use warnings;
open(IN,"$ARGV[0]") or die "$!";
open(OUT,">$ARGV[1]");
#comment:inputfile not allow the "#",besides the header descriptions,delete the header must be fine on this scripts
while(<IN>){
        &readgff($_);
}

sub readgff{
        my $line=shift;
        if($line =~/mRNA/){
                my @array=split /\s+/,$line;
                print OUT $array[0],"\t",$array[1],"\t","gene","\t",$array[3],"\t",$array[4],"\t",$array[5],"\t",$array[6],"\t",$array[7],"\t",$array[8],"\n";
                $array[8]=~s/(ID\=Bras_T[0-9]+)(.*)/$1\.1$2/g;
                $array[8]=~m/ID\=(Bras_T[0-9]+)(.*)/;
                print OUT $array[0],"\t",$array[1],"\t",$array[2],"\t",$array[3],"\t",$array[4],"\t",$array[5],"\t",$array[6],"\t",$array[7],"\t","$array[8]",";","Parent=$1\.1","\n";
        }else{
                my @array1=split /\s+/,$line;
                if(@array1 !=9){
                        print OUT $line;
                }else{
                        if($line !~/gene/){
                                 $array1[8]=~s/(ID\=Bras_T[0-9]+)(.*)/$1\.1$2/g;
                                print OUT $array1[0],"\t",$array1[1],"\t",$array1[2],"\t",$array1[3],"\t",$array1[4],"\t",$array1[5],"\t",$array1[6],"\t",$array1[7],"\t","$array1[8]\.1","\n";
                        }

                }
                $line=<IN>;
                if(eof(IN)){
                        exit;
                }
                &readgff($line);
        }
}
close IN;
close OUT;
