use warnings;
use strict;

die "perl $0 iv.file batch_prefix\n" unless (@ARGV==2);
my $iv_file=shift;
my $batch=shift;

my %individuals;
my @cor;
open I, $iv_file or die $!;
<I>;
my @loci;
while(<I>){
        chomp;
        if($_=~/^Recombs/){
                next;
        }
        if($_=~/^Totals/){
                next;
        }

        if($_!~/^chrII/){
                print STDERR "$_\n";
                next;
        }
        my @tmp=split /,/, $_;
        my $header=shift @tmp;
#       chrIV:170
        my $cor=substr($header,6);
        push @loci,$cor;

        if($.<4){
                print STDERR "$header\n";
                print STDERR "$cor\n";
        }
        foreach my $i(0 .. $#tmp){
                if(($tmp[$i] eq "A")||($tmp[$i] eq "B")){
                        push @{$individuals{$i}}, $tmp[$i];
                }
        }
}

foreach my $key(keys %individuals){
        open OUT,">$batch.individual.$key.txt" or die $!;
        foreach my $j(0 .. $#{$individuals{$key}}){
                my $tmp0=$loci[$j];
                my $tmp1=$individuals{$key}->[$j];
                print OUT "$tmp0\t$tmp1\n";
        }
}
