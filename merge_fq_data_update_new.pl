#!/usr/bin/perl
use Getopt::Long;
use File::Basename qw(basename dirname fileparse);
use Cwd qw(abs_path getcwd);
use FindBin qw($Bin $Script);
my $version="11-15";
my $program="$Script";

my ($indir1,$indir2,$od,$step);
GetOptions(
	"h|?" => \&USAGE,
	"c:s" => \$indir1,
	"m:s" => \$indir2,
	"step:s" => \$step,
	"o:s" => \$od,
) or &USAGE;

&USAGE unless ($indir1 or $indir2 or $od);
$step ||=0;
$od ||="merge_result";

#glob variable build below and preprocessing
mkdir "$od" unless -d "$od";
my $loc=abs_path($od);
mkdir "$loc/worK_sh1" unless -d "$loc/work_sh1";  #unless statement don't work as use the anti-quota mark,``.
my $path="$loc/worK_sh1";

#input cleandata dir
my %file=();
my $abs_path=abs_path($indir1);
if($step == 0){
	my @file=glob "$abs_path/*fq";
	for my $file(sort @file){
		chomp $file;
		my $basename=basename($file);
		my @identifier=split /\_/,$basename;  # #Sample_M191-01-T01_good_2.fq.gz
		$file{$identifier[1]}{$identifier[3]}=$file;
	}
	$step++ if($step == 0);
}


#input merge dir
if($step==1){
	open(OUT,">$path/step1.merge.sh");
	open(OUT1,">$path/size.sh");
	my $abs_path1=abs_path($indir2);
	my @file1=glob "$abs_path1/*fq";	
	for my $file1(sort @file1){
		chomp($file1);
		my $basename=basename($file1);
		my @identifier=split /\_/,$basename;
		if(exists $file{$identifier[1]}){  #Firstly for hash key judgement (if conditional judgement)
			if(exists ${$file{$identifier[1]}}{$identifier[3]}){ #twice judge the key 
				my $clean_fq_name=basename($file{$identifier[1]}{$identifier[3]}); #cleandata name
				print LOG $merge_and_cleandata_fq;
				my $cmd="cat $file1 $file{$identifier[1]}{$identifier[3]} \> $loc/$clean_fq_name";
				my $merge_and_cleandata_and_result_fq_size="du -sh $file1 $file{$identifier[1]}{$identifier[3]} $loc/$clean_fq_name>>$path/Size_fq.log";
				print OUT1 $merge_and_cleandata_and_result_fq_size,"\n";
				print OUT $cmd,"\n";
			}
		}

	}	
	close OUT;
	close OUT1;

	
	#Throw qsub start...

	my $sh1="$path/step1.merge.sh";
	my $sh2="$path/size.sh";
	print "Start merge with qsub\n";
	system "sh /v1.0/qsub_sge.plus.sh $sh1 --reqsub --independent";
	system "sh /v1.0/qsub_sge.plus.sh $sh2 --reqsub --independent";
		
	$step++ if($step ==1);

}

if($step == 2){
	open(OUT,">$path/step2.copy.sh");
	my @file3=glob "$loc/*fq";
	for my $file(sort @file3){
		my $cmd="cp $file $abs_path/";
		print OUT $cmd,"\n";
	}
	close OUT;
	my $sh1="$path/step2.copy.sh";
	#Throw qsub start...
	print "Start copy merge file into cleandata\n";
	system "sh /v1.0/qsub_sge.plus.sh $sh1 --reqsub --independent";
	$step++ if($step ==2);
}

#######################################
#start batch compress with cleandata

if($step == 3){
	print "Start gzip fq data\n";
	print "$abs_path\n";
	my $cmd	="perl /v1.0/compress_and_check_fq.pl -i $abs_path -od gz_data";
	system "$cmd";
	$step++ if($step == 3);
}


#As reach 4 the program exit
if($step == 4){
	my @delfile=`rm -r $path/*fq`;  #del temp dir fqdata
	print STDOUT "Starting delete the temp dir $od fq-data\n";
	while(<@delfile>){
		print STDOUT $_,"\n";
	}
	print STDOUT "All works finished!\n";
}

sub USAGE{
	my $usage=<<"USAGE";
	Program name:$program
	program version:$version
	Contact:939869915\@qq.com
	-step 0-3 [default 0]
	0 merge step
	1 copy file to cleandata
	2 gzip cleandata
	3 rm temprary dir
	-o output dir [default merge_result]
	-c cleandata dir
	-m merge dir
	-o default <merge_result>
	For example:
	perl $0 -m <dir> -c <dir> -o <dir> -step [0-3]
USAGE

	print $usage;
	exit;
}
