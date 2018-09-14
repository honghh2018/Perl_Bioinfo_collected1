advanced usage for Getopt::Long;
if you want to be special at perl command line parameter,you should use array to tranfer your para.
the usage show as below:
use Getopt::Long;
my @array;
GetOptions(
  "-al:s" =\@array
);
open(IN1,"$array[0]") or die $!;
open(IN2,"$array[1]") or die "$!";  
open(OUT,">$ARGV[0]");  #
while(<IN1>){
  print OUT $_;
}
while(<IN2>){
  print OUT $_;
}
close IN1;
close IN2;
close OUT;
##usage:
Getopt::Long_involved_parameter.pl -al 1.txt -al 2.txt result  #the "result"　parameter was output file,it take by @ARGV

comment:you should know that GetOptions parameter have not occupied the ARGV parameter　count,so,when you use @ARGV,you should start with $ARGV[0]
not $ARGV[1] or $ARGV[2].the example show as below:
##


#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;

my @array;
GetOptions(
        "-al:s" => \@array
);

open(IN1,"$array[0]") or die "$!";
open(IN2,"$array[1]") or die "$!";
open(OUT,">$ARGV[0]");

while(<IN1>){
        print OUT $_;
}
while(<IN2>){
        print OUT $_;
}
close IN1;
close IN2;
close OUT;


