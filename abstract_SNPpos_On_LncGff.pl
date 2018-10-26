
#!/usr/bin/perlLgff
use strict;
use warnings;
use File::Basename qw'basename dirname';
use Getopt::Long;


my(@infile,$od);
GetOptions(
	"i:s{,}" => \@infile, #space segmenting
	"o:s" => \$od,
	"h|?" => \&USAGE,
) or &USAGE;

open(IN,"$infile[0]") or die "$!";  #
open(IN1,"$infile[1]") || die "$!";
open(OUT,">$od");


my %SNP=(); #snp or inDel
while(<IN1>){
        chomp;
        my($chr,$pos,$left)=split /\s+/,$_,3;
        $SNP{$chr}{$pos}=$left;
}



my %Lgff=();
while(<IN>){
	chomp;
	if(/mRNA/){
		my ($chr,$start,$end,$lnc_id)=(split /\s+/,$_)[0,3,4,8];
		$lnc_id=(split /\;/,(split /\=/,$lnc_id)[1])[0];
		if(exists $SNP{$chr}){
			for my $sec_key(keys %{$SNP{$chr}}){
				if($sec_key >= $start && $sec_key <= $end){
					print OUT $chr,"\t",$sec_key,"\t",$SNP{$chr}{$sec_key},"\t",$lnc_id,"\n"; 
				}else{
					next;
				}
			}
		}
		
	}
}
	

close IN;
close IN1;
close OUT;

sub USAGE{
	my $usage =<<USAGE;
	USAGE:
	\$perl $0 -i [infile1 infile2] -o outfilename
	CONTACT:honghh\@biomarker.com.cn
	
USAGE
	print $usage;
	exit;
}


