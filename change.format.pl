use strict;
use warnings;

die "perl $0 chr family.config\n" unless(@ARGV==2);
my $chr=shift;
my $family_config=shift;

my $tmp_dir="/fml/chones/projects/PJ023_FamilyRecomb/marine_X20/5.SNP/samtools_filter/ped";
if(!-e "$tmp_dir/$chr"){
        `mkdir $tmp_dir/$chr`;
}

my $outdir="$tmp_dir/$chr";
my $map_file="$chr.map";
my $ped_file="$chr.ped";

open I, $map_file or die $!;
open MAPOUT,">$outdir/$chr.new.map" or die $!;
open MAPDATOUT, ">$outdir/$chr.markers.dat" or die $!;
while(<I>){
        chomp;
        my ($id,$bp)=(split)[1,3];

        my $chr_short;
        if($chr=~/chr(\d+)/){
                $chr_short=$1;
        }
        print MAPOUT "$chr_short\t$id\t0.1\t$bp\n";
        print MAPDATOUT " M\t$id\n";
}
close MAPOUT;

my ($FamilyId,$PaternalId,$MaternalId);
my %frole;
open II,$family_config or die $!;
while(<II>){
        chomp;
        my ($id,$familyid,$role,$gender)=split;
        $FamilyId=$familyid;
        if($role eq "FATHER"){
                $PaternalId=$id;
        }else{
                $MaternalId=$id;
        }
        $frole{$id}=$role;
}


my ($good_paternal_info,$good_maternal_info,$count);
my @children;
open III, $ped_file or die $!;
while(<III>){
        chomp;
        my @tmp=split;
        my @genotype=@tmp[6 .. $#tmp];
        my $sid=$tmp[0];

        if(exists $frole{$sid}){
                my $idrole=$frole{$sid};
                if($idrole eq "MOTHER"){
                        my $header="$FamilyId\t$sid\tx\tx\t2\t0";
                        $good_maternal_info=&format_line(\@genotype);
                        $good_maternal_info=$header."\t".$good_maternal_info;
                }else{
                        my $header="$FamilyId\t$sid\tx\tx\t1\t0";
                        $good_paternal_info=&format_line(\@genotype);
                        $good_paternal_info=$header."\t".$good_paternal_info;
                }
                next;
        }

        my $header="$FamilyId\t$sid\t$PaternalId\t$MaternalId\t0\t0";
        my $good_child_info=&format_line(\@genotype);
        $good_child_info=$header."\t".$good_child_info;
        push @children, $good_child_info;
}

foreach my $i (0 .. $#children){
        if($i % 16==0){
                $count++;
                my $filename="$chr.batch$count.ped";
                open PEDOUT,">$outdir/$filename" or die $!;
                print PEDOUT "$good_paternal_info\n";
                print PEDOUT "$good_maternal_info\n";
        }

        print PEDOUT "$children[$i]\n";
}

sub format_line{
        my $ref=shift;
        my @genotypes=@{$ref};
        my $output;

        my %base=(
                "."=>"0",
                "A"=>"1",
                "T"=>"2",
                "C"=>"3",
                "G"=>"4"
        );
        
        for(my $i=0;$i<=$#genotypes;$i+=2){
                my $gt1=$genotypes[$i];
                my $gt2=$genotypes[$i+1];

                if(exists $base{$gt1}){
                        $gt1=$base{$gt1};
                }

                if(exists $base{$gt2}){
                        $gt2=$base{$gt2};
                }

                my $tmp=$gt1."/".$gt2;
                $output.="\t$tmp";
        }
        return $output;
}
