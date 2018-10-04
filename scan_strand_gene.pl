#!/usr/bin/perl
use strict;
use warnings;
use Tie::File;
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
my @file;
open(IN,"$para{i}") or die "$!";
open(OUT,">$para{o}");
open(OUT1,">filter_id_2018.txt");
open(TEMP,">Temp.list");

##filter file header of gff3 build middle file
my @header=();
while(<IN>){
	chomp;
	if($_=~/^##.*\d+$/){
		push @header,$_;
		next;
	}else{
		print TEMP $_,"\n"; 
	}
}
close TEMP;
#print header description
for(@header){
	print OUT $_,"\n";
}
open(IN1,"Temp.list") or die "$!";
tie @file,'Tie::File',\*IN1, recsep => '###',autochomp => 0;


my $count=0;
for my $line(@file){
	chomp($line);
	if($line=~/\+.*\-/smg || $line=~/\-.*\+/smg){
		my $gene_id=(split /\;/,(split /\s+/,(split /\n+/,$line,2)[1])[8])[0];
		$count++;
		print OUT1 $gene_id,"\n";
	}else{
		print OUT $line;
	}

}
print OUT1 "Number of gene on both positive strand and negative strand:",$count,"\n";

close IN;
close OUT;
close OUT1;
close IN1;
`rm -r Temp.list` if(-e "Temp.list");
