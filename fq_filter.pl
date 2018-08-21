#!/usr/bin/perl -w
use strict;
use FindBin '$Bin';
use Cwd qw(abs_path getcwd);
use Getopt::Long;


#getoptions
my($infile,$outfile,$cutoff,$switch)
GetOptions(
  "input:s"  => \$infile,
  "output:s" => \$outfile,
  "scale:s"  => \$cutoff,
  "cr"       => \$switch,
  "h|?"      => \&USAGE,
) or &USAGE;
$cutoff ||="60-80";
&USAGE unless($infile and $outfile);
my $localpath=getcwd;
`mkdir -p "$localpath/Result"` unless (-d "$localpath/Result");
open(my $out,">$localpath/Result/$outfile.fastq");
&read_fastq($infile,$cutoff);
close $out;

sub read_fastq{
  my ($file,$range)=@_;
  my $abs_file=abs_path($file);
  my @arr_cutoff=(split/\-/,$range);
  open(my $fastq,"$abs_file") or die "$!"; #scalar reference file handle, and $fastq must be undefine
  my @arrdata=();
  while(my $line=<$fastq>){
    chomp($line);
    push @arradata,$line;
  }
  for(my $i=0;$i<=$#arrdata;$i +=4){
    next if($arr_cutoff[0]>strlen($arrdata[$i+1] || strlen($arrdata[$i+1]>$arr_cutoff[2]));
    print {$out} $arrdata[$i],"\n";
    print {$out} $arrdata[$i+1],"\n";
    print {$out} $arrdata[$i+2],"\n";
    print {$out} $arrdata[$i+3],"\n";
  }
  close $fastq;
}
my %count_read=();
my $string_log="start statistic repeative read count";
if(undef $switch){
  print $string_log,"\n";
  print "start:\n";
  &statistic_reads($outfile);
  &intergration($outfile,\%count_read);
}

sub statistic_reads{
  my $file=shift;
  my $abs_file=abs_path($file);
  open(my $in,"$abs_file") or die "$!";
  while(my $line=<$in>){
    chomp($line);
    my $line_1=$line;
    my $line_2=<$in>;
    my $line_3=<$in>;
    my $line_4=<$in>;
    $count_read{$line_2}++;
  }
  close $in;
}

sub intergration{
  my ($file,$count)=@_;
  my $abs_file=abs_path($file);
  open(my $in,"$abs_file") or die "$!";
  open(my $out,">$localpath/Result/$outfile.count");
  while(my $line=<$in>){
    chomp($line);
    my $line_1=$line;
    my $line_2=<$in>;
    my $line_3=<$in>;
    my $line_4=<$in>;
    if(exists $count->{$line_2}){
        print {$out} "Repeative read counts:","\n";
        print {$out} $line_1,"\t","COUNT:",$count->{$line_2},"\n";
        print {$out} $line_2,"\n";
        print {$out} $line_3,"\n";
        print {$out} $line_4,"\n";
    }
  }
  close $in;
  close $out;
}


sub USAGE{
  my $usag=<<"USAGE";
  ----------------------------------------------------
  Manual page:
    Contact:honghh\@biomarker.com.cn
  Usage:
    Options:
    -input fastq file,forced;
    -output fastq prefix,forced;
    -scales threshold value;
    -cr open statistic repeative read count switch
    -h  show the help;
  Example:
    fq_filter.pl -input <file> -ouput <file> -scales [INT] -cr
  ----------------------------------------------------
  USAGE
  print $usage;
  exit(1);
}
