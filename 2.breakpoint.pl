use strict;
use warnings;

die "perl $0 batch1.individual.0.txt  >batch1.individual.0.breakpoint" unless(@ARGV==1);
my $file=shift;

my $last_type;
my $last_cor;
my $count;
my %record;
my @coordinates;
open I, $file or die $!;
while(<I>){
        chomp;
        my ($cor,$type)=split;
        push @coordinates, $cor;
        if($.==1){
                $last_type=$type;
                $last_cor=$cor;
        }

        if($type eq "0"){
                next;
        }

        $type=uc($type);
        $count++;
        if($type ne $last_type){
                push @{$record{$last_cor}},$last_type;
                push @{$record{$last_cor}},$count;
                $last_cor=$cor;
                $last_type=$type;
                $count=0;
        }
}

my %rc;
foreach my $i(1 .. $#coordinates){
        my $j=$i-1;
        $rc{$coordinates[$i]}=$coordinates[$j];
}

my @tmp_vector_end;
foreach my $key(sort {$a <=>$b} keys %record){
        if(exists $rc{$key}){
                my $end=$rc{$key};
                my $distance=$end-$key;
                push @tmp_vector_end,$end;
        }else{
                push @tmp_vector_end,"NA";
        }
}

push @tmp_vector_end, "NA";
my $i=0;
foreach my $key(sort {$a <=>$b} keys %record){
        print "$key\t";
        print join "\t",@{$record{$key}};
        $i++;
        print "\t$tmp_vector_end[$i]\n";
}
