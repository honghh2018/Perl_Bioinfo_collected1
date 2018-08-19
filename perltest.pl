#!/usr/bin/perl -w
use strict;
use FindBin '$Bin';  #use Find::Bin在linux可以但是在Windows是FindBin
use Cwd qw(abs_path getcwd);
use Getopt::Std;
use Getopt::Long;


#The input parameter designed
#------------------------------------------
#GetOptions
#------------------------------------------

my ($config,$datapath,$output);
GetOptions(
	"h|?" 		=>\&USAGE,      #print the usage
	"config:s"	=>\$config,     #input first document
	"datapath:s"	=>\$datapath,   #input absolute path to the data
	"od:s"		=>\$output,	#output the result
) or &USAGE;

&USAGE unless($config and $datapath and $output); #if scalar no define(false) ,execute function USAGE

sub USAGE{
	my $usage=<<"USAGE";
	Description:
		Contact:honghh\@biomarker.com.cn
		function:........
	Usage:
		Options:
		
		-config		configure file,forced;
		
		-datapath	data file,forced;
		
		-od		output result file,must be given;
		
		-h		Help;
	Example:
	
	USAGE
		print $usage;  #打印标量
		exit(1); #退出码1		
}





