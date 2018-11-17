#!/usr/bin/perl
use Cwd qw(abs_path getcwd);
use FindBin qw($Bin $Script);
use Getopt::Long;
use strict;
use warnings;
my $begin=time();
my $version="1.0";
my ($indir,$outdir);
GetOptions(
	"h|?" => \&USAGE,
	"indir:s" => \$indir,
) or &USAGE;

if(!defined $indir){
	&USAGE;		
}
my $inpath=abs_path($indir);
my $wc="work_sh";
mkdir $wc unless -d "$wc";
my $abs_path=abs_path($wc);
open(SH,">$wc/step.uncompress.sh");
my @gzfile=glob "$inpath/*gz";  #read all of files
	
for my $file(@gzfile){
	chomp$file;
	my $cmd="gunzip $file";
	print SH $cmd,"\n"; 
}
close SH;
#Throw qsub start...;

print "Start throw qsub... \n";
my $sh="$abs_path/step.uncompress.sh";
system "sh /share/v1.0/qsub_sge.plus.sh $sh --reqsub --independent";
my $end=time();
####elapse time
my $elapse=$end-$begin;
print "\nDone Total elapse time:","$elapse s";

sub USAGE{
	my $usage=<<USAGE;
	Program: $Script;
	Version: $version;
	Contact:939869915\@qq.com
	perl $0 -indir <gzfile>
USAGE
	print $usage;
	exit;
}	
