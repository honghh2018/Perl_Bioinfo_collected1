#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use Cwd qw(abs_path getcwd);
use FindBin '$Bin';
use Benchmark;

#Description:
my $version="RC18.8.19";
my $author="HONGHH";
my $orgnization="www.Biomarker.com.cn";
my $Description="The scripts used to Reverse the sequences,which can rapidly manipulate your result produced by sequencing";
#Strart the worK
#Standard your parameter,just read our manual page to set the input parameter.
my($config,$outfile,$GC);
GetOptions(
  "config:s"  =>\$config,   #input your configure file if you want to create your project
  "outdir:s" =>\$outfile,   #point your directory for the disposal result
  "GC:s"  =>\$GC,             #calculate the GC content（1，performance GC statistic,default 0）
  "h|?" =>\$USAGE,          #when you make a mistake,you type -h or -? for help
) or &USAGE;
&USAGE unless($config and $outfile);

$GC ||=0;
my @abs_path_data=();
`mkdir "$Bin/Result"` unless(-d "$Bin/Result");
#invoking below function for reading configure
&read_config($outfile);
chdir "$Bin/Result" if(-d "$Bin/Result");
`mkdir $outfile`;
#invoking below function for RC
&Reverse_Complement(@abs_path_data) && `echo "this work was completely success" && touch "check.$data"`;
if($GC==1){
  &GC_statistic();
}

###################################################
#using below function for statistic the GC content
sub GC_statistic{
  my @dataarray=@_;
  my $localpath=abs_path($outfile);
  open(OUT,">$localpath/GC_statistic.txt");
  for(@dataarray){
    my $time=&show_log($_);
    my $timestamp1->new;
    open(IN2,"$_") or die "$!";
    my $filename=split(/\./,split(/\//,$_)[-1])[0];
    for my $line(<IN2>){
      chomp($line);
      my $id;
      my $seq;
      if($line=~/(^>.*)/){
        $id=$1;
        print OUT $version,"\t",$author,"\t",$orgnization,"\n";
        print OUT $Description,"\n";
        print OUT "WorK start:",$time,":",$filename,"\n";
        print OUT $id,"\n";
        print OUT "A BASE\tT BASEC BASE\tG BASE\tGC Content:","\n";
      }else{
        $seq .=$seq;
        my($count_A,$count_T,$count_C,$count_G,$GC);
        while($line=~/A/ig){$count_A++}
        while($line=~/T/ig){$count_T++}
        while($line=~/C/ig){$count_C++}
        while($line=~/G/ig){$count_G++}
        my $total=$count_A+$count_T+$count_C+$count_G;
        $GC=($count_C+$count_G)/$total;
        print OUT $count_A,"\t","$count_T","\t",$count_C,"\t",$count_G,"\t",$GC,"\n";
      }
    }
    my $timestamp2->new;
    my $runtime=timediff($timestamp2, $timestamp1); #get the difference time
    print OUT "runing time:","timestr($runtime)","\n";
    print OUT "-------------------------------------------------------\n";
    close IN2;

  }
  close OUT;
}

###################################################
sub show_log{
  my($txt)=@_;
  my $time=time();
  my($sec,$min,$hour,$day,$mon,$year,$wday,$yday,$isdst)=localtime($time);
  $wday=$yday=$isdst=0;
  my $Time=sprintf("%4s-%2s-%2s %2s:%2s:%2s",$year+1900,$mon+1,$day,$hour,$min,$sec);
  print "$Time:\t$txt\n";
  return($time);
}

###################################################
sub Reverse_Complement{
  my @dataarray=@_;
  for(@dataarray){
    open(IN2,"$_") or die "$!";
    my $localpath=abs_path($outfile);
    my $filename=split(/\./,split(/\//,$_)[-1])[0];
    open(OUT,">$localpath/$filename_good.fa");
    for my $line(<IN2>){
      chomp($line);
      my $id;
      my $seq;
      if($line=~/(^>.*)/){
        $id=$1."Reverse_Complement"."\n";
        print OUT $id,"\n";
      }else{
        $seq .=$seq;
        $seq=~tr/ATCG/TAGC/ig;
        $seq=reverse($seq);
        print OUT $seq,"\n";
      }
    }
    print OUT $version,"\t",$author,"\t",$orgnization,"\n";
    print OUT $Description,"\n";
    close IN2;
    close OUT;
  }
}

###################################################
sub read_config{
  my ($cfg)=shift;
  my $cfg_abs_path=abs_path($cfg);
  open(IN1,"$cfg_abs_path") or die "$!";
  while(my $line=<IN>){
    next if($line=~/^#/);
    if($line=~/^fa1/){
      push  @abs_path_data  split(/\=/,$line)[1];
    }
  }
  close(IN1);
}

###################################################
sub $USAGE{
  my $usage =<<"USAGE";
  ---------------------------------------------
  Manual page:
    Contact:honghh\@biomarker.com.cn
  Usage:
    Options:
    -config configure file,forced;
    -outdir output directory,forced;
    -GC whether add GC calculate;
    -h  show the help;
  Example:
    Reverse_Complement.pl -config <config_file> -outdir <file_path> -GC <1 or 0>
    ---------------------------------------------
  USAGE
  print $usage;
  exit(1);
}
###################################################
#copy this script in your workdirectory,and move your data in some suitable place(for Linux)
#set your configure file,the format show below:
__END__
#The script function was Reverse Complement the sequences
#input srcdata absolute pathway
fa1=${home}/workdirectory/
fa2=${home}/workdirectory/
fa3=...
#end
