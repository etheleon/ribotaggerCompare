#note mothur doesnt accept dash character have to manually escape it (i havent gone about doing it)
Seqfile='/data/Day1_AERO_Sample02-combined.fasta'
Cpu='6'   # number of maxixum threads for search and alignment
Hmm='./data/SSUsearch_db/Hmm.ssu.hmm'   # hmm model for ssu
Gene='ssu'
Script_dir='/compare/SSUsearch/scripts'
Gene_model_org='./data/SSUsearch_db/Gene_model_org.16s_ecoli_J01695.fasta'
Ali_template='./data/SSUsearch_db/Ali_template.silva_ssu.fasta'

# pick start and end of a region in V4 for de novo clustering
# the default numbers are for 150bp reads
# rule of thumb is pick a region with more reads with larger overlap
# change to Start=577, End=657, Len_cutoff=75 for 100bp reads
Start='577'
End='727'
Len_cutoff='100' # min length for reads picked for the region

Gene_tax='./data/SSUsearch_db/Gene_tax.silva_taxa_family.tax' # silva 108 ref
Gene_db='./data/SSUsearch_db/Gene_db.silva_108_rep_set.fasta'

Gene_tax_cc='./data/SSUsearch_db/Gene_tax_cc.greengene_97_otus.tax' # greengene 2012.10 ref for copy correction
Gene_db_cc='./data/SSUsearch_db/Gene_db_cc.greengene_97_otus.fasta'

###
### do not need to change lines below
###

### first part of file basename will the label of this sample
Filename=$(basename $Seqfile)
Tag=${Filename%%.*}

### make absolute path
export Hmm=$(readlink -f ${Hmm})
export Seqfile=$(readlink -f ${Seqfile})
export Script_dir=$(readlink -f ${Script_dir})
export Gene_model_org=$(readlink -f ${Gene_model_org})
export Ali_template=$(readlink -f ${Ali_template})
export Gene_tax=$(readlink -f ${Gene_tax})
export Gene_db=$(readlink -f ${Gene_db})
export Gene_tax_cc=$(readlink -f ${Gene_tax_cc})
export Gene_db_cc=$(readlink -f ${Gene_db_cc})
echo "*** make sure: parameters are right"
echo "Seqfile: $Seqfile\nCpu: $Cpu\nFilename: $Filename\nTag: $Tag"
cd /compare/workdir
mkdir -p $Tag.ssu.out

### start hmmsearch
echo "*** hmmsearch starting"
time hmmsearch --incE 10 --incdomE 10 --cpu $Cpu \
  --domtblout $Tag.ssu.out/$Tag.qc.$Gene.hmmdomtblout \
  -o /dev/null -A $Tag.ssu.out/$Tag.qc.$Gene.sto \
  $Hmm $Seqfile
echo "*** hmmsearch finished"
python $Script_dir/get-seq-from-hmmout.py \
    $Tag.ssu.out/$Tag.qc.$Gene.hmmdomtblout \
    $Tag.ssu.out/$Tag.qc.$Gene.sto \
    $Tag.ssu.out/$Tag.qc.$Gene
echo "*** Starting mothur align"
cat  $Gene_model_org $Tag.ssu.out/$Tag.qc.$Gene > $Tag.ssu.out/$Tag.qc.$Gene.RFadded

# mothur does not allow tab between its flags, thus no indents here
#time mothur "#align.seqs(candidate=$Tag.ssu.out/$Tag.qc.$Gene.RFadded, template=$Ali_template, threshold=0.5, flip=t, processors=$Cpu)"

#real    665m42.659s
#user    2124m14.992s
#sys     78m59.096s
 
rm -f mothur.*.logfile
python $Script_dir/mothur-align-report-parser-cutoff.py \
    $Tag.ssu.out/$Tag.qc.$Gene.align.report \
    $Tag.ssu.out/$Tag.qc.$Gene.align \
    $Tag.ssu.out/$Tag.qc.$Gene.align.filter \
    0.5
python $Script_dir/remove-gap.py $Tag.ssu.out/$Tag.qc.$Gene.align.filter $Tag.ssu.out/$Tag.qc.$Gene.align.filter.fa
python $Script_dir/region-cut.py $Tag.ssu.out/$Tag.qc.$Gene.align.filter $Start $End $Len_cutoff
 
mv $Tag.ssu.out/$Tag.qc.$Gene.align.filter."$Start"to"$End".cut.lenscreen $Tag.ssu.out/$Tag.forclust
rm -f $Tag.ssu.out/$Tag.qc.$Gene.align.filter.*.wang.taxonomy
 echo "classify.seqs(fasta=$Tag.ssu.out/$Tag.qc.$Gene.align.filter.fa, template=$Gene_db, taxonomy=$Gene_tax, cutoff=50, processors=$Cpu)"
mothur "#classify.seqs(fasta=$Tag.ssu.out/$Tag.qc.$Gene.align.filter.fa, template=$Gene_db, taxonomy=$Gene_tax, cutoff=50, processors=$Cpu)"
mv $Tag.ssu.out/$Tag.qc.$Gene.align.filter.*.wang.taxonomy \
   $Tag.ssu.out/$Tag.qc.$Gene.align.filter.wang.silva.taxonomy
python $Script_dir/count-taxon.py \
    $Tag.ssu.out/$Tag.qc.$Gene.align.filter.wang.silva.taxonomy \
    $Tag.ssu.out/$Tag.qc.$Gene.align.filter.wang.silva.taxonomy.count
rm -f mothur.*.logfile
