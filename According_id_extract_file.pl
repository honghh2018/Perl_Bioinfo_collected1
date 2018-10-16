#!/usr/bin/perl -w
use strict;
use warnings;
use Cwd qw 'abs_path getcwd';

my $path=abs_path($ARGV[0]);

my @filename=glob "$path/*";
open(IN,"$ARGV[1]") or die $!;
open(OUT,">merge_result.list");
my @filter_id=();
while(<IN>){
	chomp;
	my $gene_id=(split /\s+/,$_)[1];
	push @filter_id,$gene_id;
}


while(<@filename>){
	chomp;
	print $_,"\n";
	open(IN1,$_) or die "$!";
	while(my $line=<IN1>){
		chomp $line;
		my $gene_id=(split /\s+/,$line)[0];
		for my $abstract_id(@filter_id){
			if($gene_id eq $abstract_id){
				print OUT $line,"\n";
			}
		}
	}
	close IN1;	

}

close IN;
close OUT;
