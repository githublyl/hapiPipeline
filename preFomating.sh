
chr=$1
family_config="family.config"

dir="/fml/chones/projects/PJ023_FamilyRecomb/marine_X20/5.SNP/samtools_filter/step5/test"
vcffile="$dir/$chr.snp.individual_filter.good_samples.least_na.informative.vcf"
echo "$vcffile"

vcftools --vcf $vcffile --plink --out $chr

perl change.format.pl $chr  $family_config


echo "/fml/chones/projects/PJ023_FamilyRecomb/marine_X20/5.SNP/samtools_filter/ped/chr4"
