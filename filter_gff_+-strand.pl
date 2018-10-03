#!/usr/bin/perl 
use strict;
use warnings;

open(IN,"$ARGV[0]") or die "$!";
open(OUT,">$ARGV[1]");

my %gene_hash=();
my $last_id="";
while(<IN>){
	chomp;
	if($_ =~/gene/){
		$last_id=(split /\;/,(split /\s+/,$_)[-1])[0};
		push @{$gene_hash{$last_id}},$_;
	}else{
		push @{$gene_hash{$last_id}},$_;		
	}
}

my @strand=();
for my $key(sort keys %gene_hash){
	for my $i(0..$#{$gene_hash{$key}}){
		@strand=(split /\s+/,${$gene_hash{$key}}[$i])[5];
	}
	my $flag=&diff(\@strand);
	if($flag ==1){
		for my $i(0..$#{$gene_hash{$key}})
		{
			print OUT ${$gene_hash{$key}}[$i],"\n";
		}
	}else{
		next;
	}
}

close IN;
close OUT;

sub diff{
	my $refar=@_;
	my $symbol=shift @{$refar};
	while(<@{$refar}>){
		if($symbol eq $_){
			$symbol=$_;
		}else{
			retunr 0;
		}
	}
	return 1;
}


