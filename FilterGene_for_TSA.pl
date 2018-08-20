#！/usr/bin/perl
use strict;
use warnings;
use FindBin '$Bin';
use Cwd qw(abs_path getcwd);
use Getopt::Long;

#######GetOptions
my($tsa,$filter_id,$outfile);
GetOptions(
  "tsa:s" => \$tsa,
  "tag:s" => \$filter_id,
  "od:s"  => \$outfile,
  "h|?"   => \&USAGE,
) or &USAGE;
&USAGE unless($tsa and $filter_id and $outfile);

my $locate=getcwd;
`mkdir "$locate/Result"` unless(-d "$locate/Result");
my %fasta_tsa=();
&read_tsa($tsa);
my $filter_id_path=abs_path($filter_id);
open(IN,"$filter_id_path") or die "$!";
open(OUT,">$locate/Result/$outfile");
while(my $line=<IN>){
  chomp($line);
  if(exists $fasta_tsa{$line}){
    delete $fasta_tsa{$line};
  }else{
    print OUT ">",$line,"\n";
    print OUT $fasta_tsa{$line};
  }
  close IN;
  close OUT;
}


sub read_tsa{
  my $file=shift;
  my $abs_file=abs_path($file);
  open(IN,"$abs_file") or die "$!";
  while(my $line=<IN>){
    chomp($line);
    my $id="";
    my $seq="";
    if($line=~/^>(.*)/){
      $id=$1;
    }else{
      $seq .=$seq;
    }
    $fasta_tsa{$id}=$seq;
  }
  close IN;
}

sub USAGE{
  my $usag=<<"USAGE";
  ----------------------------------------------------
  Manual page:
    Contact:honghh\@biomarker.com.cn
  Usage:
    Options:
    -tsa tsa file,forced;
    -tag filter id,forced;
    -od output file;
    -h  show the help;
  Example:
    FilterGene_for_TSA.pl -tsa <file> -tag <file> -od <file>
  ----------------------------------------------------
  USAGE
  print $usage;
  exit(1);
}
