#!/usr/bin/perl 
use strict;
use warnings;

open(IN,"$ARGV[0]") or die "$!";
open(IN1,"$ARGV[1]");
open(OUT,">$ARGV[2]");


my @array=();
while(<IN>){
        chomp;
        if(/^c\d+\./){
                my $id=(split/\s+/,$_)[0];
                push @array,$id;
        }

}
my %fa=();
$/=">";
while(<IN1>){
        chomp;
        next if(/^.*$/);
        my ($id,$seq)=(split /\n/,$_,2)[0,1];
        $fa{$id}=$seq;
}


while(<@array>){
        if(exists $fa{$_}){
                delete $fa{$_};
        }
}

for my $key(sort keys %fa){
        print OUT ">",$key,"\n";
        print OUT $fa{$key};
}


close IN;
close IN1;
close OUT;
