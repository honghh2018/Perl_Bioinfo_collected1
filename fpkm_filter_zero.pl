you should filter the file with awk.print specific column,for example:
cat All_fpkm.list |awk '{print $1,"\t",$2,"\t",$3,"\t",$4,"\t",$5,"\t"}' >file.txt


#!/usr/bin/perl -w
use strict;
use warnings;
open(IN,"$ARGV[0]") or die "$!";
open(OUT,">$ARGV[1]");

while(<IN>){
	chomp;
	if(/^\#/){
		print OUT $_,"\n";
		next;
	}
	my @array=split(/\s+/,$_);	
	my $id=shift(@array);
	my $sum=&add1(@array);
	next if($sum==0);
	my $fpkm=join("\t",@array);
	print OUT $id,"\t",$fpkm,"\n";
}

sub add1{
	my @array=@_;
	my $add=0;
	for(@array){
		$add +=$_;
	}
	return $add;
}



close IN;
close OUT;
