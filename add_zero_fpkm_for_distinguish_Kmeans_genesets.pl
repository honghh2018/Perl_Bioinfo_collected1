#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;

open(IN1,"$ARGV[0]") or die "$!";
open(IN2,"$ARGV[1]") or die "$!";
my $basename=basename($ARGV[0]);
open(OUT,">$basename\_result");


my %file1=();
while(<IN1>){
	chomp;
	if(/id/){
		print OUT $_,"\n";
		next;
	}
	my ($gene_id,$cluster,$left)=split /\s+/,$_,3;
	$file1{$gene_id}=[$cluster,$left]; 
}
close IN1;
#input the gene_id column
my @file2=();
while(<IN2>){
	chomp;
	push @file2,$_;
}
close IN2;
my @comparison=(1,1);
for my $line(@file2){
	if(exists $file1{$line}){
		push @comparison,${$file1{$line}}[0];
		if($comparison[-2] < $comparison[-1]){
			my $i=1;
			while($i<=15){
			    print OUT "$line\.$i","\t",$comparison[-2],"\t","0.1\t0.2\t0.3\t0.4\t0.5\t0.6\t0.7\t0.8\t0.9\t0.10\t0.11\t0.12\t0.13\t0.14\t0.15\t0.16\n";
			    $i++;
			}

		}else{
			print OUT $line,"\t",${$file1{$line}}[0],"\t",${$file1{$line}}[1],"\n";

		}
	}
}

close IN1;
close IN2;
close OUT;
