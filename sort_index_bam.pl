#!/usr/bin/perl -w
use strict;
use warnings;
use FindBin qw($Bin $Script);
use File::Basename qw(fileparse dirname basename);
use Getopt::Long;
use Cwd qw(abs_path getcwd);



my ($indir);

GetOptions(
	"h|?" => \&USAGE,
	"i:s" => \$indir,
) or &USAGE;

print STDOUT "your input not dir" unless(-d "$indir");

my $abs_path=abs_path($indir);
#Take all file of T* dir
my @file=glob "$abs_path/T*/*";

mkdir "$Bin/work_sh/" unless -d "$Bin/work_sh";

my $program_locate="$Bin";
print STDOUT "my program locate:\t",$program_locate,"\n";
print STDOUT "my scripts name:\t",$Script,"\n";

#step1 sort the bam file
my $count=0;
for my $file(sort @file){
	chomp($file);
	$count++;
	print STDOUT "file:$count\t",$file,"\n";
	my $dir=dirname($file);
	my $basename=basename($file);
	my $sample_id=(split /\./,$basename)[0];
	open(OUT,">$Bin/work_sh/$sample_id.sh");
	my $cmd="samtools sort $file $dir/$sample_id.sort.bam";
	print OUT $cmd;
	close OUT;
	system($cmd);
}
print STDOUT "Step1 work finished/n";
print STDOUT "Step2 start.../n";
sleep(1);
#step2 build the index

my @file1=glob "$abs_path/T*/*sort*";
for my $file(sort @file1){
	chomp($file);
	my $basename=basename($file);
	my $sample_id=(split /\./,$basename)[0];
	mkdir -p "$abs_path/index/$sample_id" unless -d "$abs_path/index/$sample_id";
	my $cmd="samtools index $file $abs_path/index/$sample_id/";
	system($cmd);
}



sub USAGE{
	my $usage=<<USAGE;
	Contact:939869915\@qq.com
	Usage:
	perl $0 -i <dir>
USAGE
	print "$usage\n";
	exit;

}
