#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
use File::Basename;

my($go,$key,$out);
GetOptions(
	"h|?" => \&USAGE,
	"go:s" => \$go,
	"k:s" => \$key,
	"o:s" => \$out,
);

&USAGE unless (defined $go or defined $key or defined $key);
if(!defined $out){
	$out ||="Result.list";
}
open(OUT,">$out");
open(IN,"$key") or die $!;
my @key=();
while(<IN>){
	chomp;
	push @key,$_;	
}
close IN;
open(IN,"$go") or die "$!";
my %anno=();
while(<IN>){
	chomp;
	next if(/\#/);
	my ($gene,$left)=(split /\s+/,$_,3)[0,2];
	$anno{$gene}=$left;
}
close IN;
foreach my $kw(@key){
        if($kw =~m/^\#/){
                next;
        }
	foreach my $gene(sort{$a cmp $b} keys %anno){
		if($anno{$gene}=~m/$kw/i){
			print OUT $gene,"\t",$anno{$gene},"\n";
		}	
	}
}
close OUT;
sub USAGE{
	my $usage=<<"USAGE";
	usege:
	perl $0 -go <go.anno> -k <file with key> -o <default:Result>
USAGE
	print $usage,"\n";
	exit;
}
