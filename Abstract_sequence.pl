#!/usr/bin/perl
use strict;
use warnings;
use FindBin '$Bin';
use Cwd qw(abs_path getcwd);
use Getopt::Long;


#getoption
my($cfg,$fa,$od)
GetOtions(
  "cfg:s" => \$cfg,    #input goal seqence id
  "f:s"   => \$fa,     #input be abstracted fasta file
  "od:s"  => \$od,     #output file
  "h|?"   => \&USAGE,  #if have some confuse,type -h saw how the scripts worK
) or &USAGE;
&USAGE unless($cfg and $fa);

&show_log;

my $localcfg=abs_path($cfg);
&read_config($localcfg);
my @config_data=();
sub read_config{
  my $file=shift;
  open(IN,"$file") or die "$!;
  while(my $line=<IN>){
    chomp($line);
    next if($line=~/^\#/);
    if($line=~/^\w+|^\d+/){
      push @config_data,$line;
    }
    close IN;
  }
}

`mkdir -p "$Bin/Result"` unless(-d "$Bin/Result");
my %fasta;
$/=">";
&read_fa($fa);
sub read_fa{
  my $file=shift;
  my $abs_path=abs_path($file);
  open(IN,"$abs_path") or die "$!";
  while(my $line=<IN>){
    chomp($line);
     next if($line=~/^$/);
     my @array=(split/\n/,$line,2);
     $array[1]=~s/\n//g;
     fasta{$array[0]}=$array[1];
  }
  close IN;
}
$/="\n";


my $resultfile="$Bin/Result/$fa_success";
open(OUT,">$resultfile");
foreach my $goal_id(@config_data){
  foreach my $fasta_id(keys %fasta){
    if($fasta_id=~/$goal_id/ig){
      print OUT "Target sequence show below:\n";
      my $time=time();
      print OUT $time,"\n";
      print OUT ">",$fasta_id,"\n";
      print OUT $fasta{$fasta_id};
    }
  }
}
close OUT;

sub show_log{
  print "Work start:\n";
  print "---------------------------------\n";
  my $time=time();
  print $time,"\n";
  print "---------------------------------\n";
}


sub USAGE{
    my $usage=<<"USAGE";
    ----------------------------------------
    Manual page:
      Contact:honghh\@biomarker.com.cn
    Usage:
      Options:
      -cfg configure file,forced;
      -f input file<fastq>,forced;
      -od output file<fasta>;
      -h  show the help;
    Example:
      Abstract_sequence.pl -cfg <config_file> -f <fasta> -od <output_file>
    ----------------------------------------
      USAGE
      print $usage;
      exit(1);
}


#description:
#you should configure your seqence id into file.
#the format show as follows:
__END__
#title:ostreagigastnunb for example
ITG_00003
ITG_00008
ITG_00021
ITG_00033
ITG_00089
Phytophthora infestans
...
