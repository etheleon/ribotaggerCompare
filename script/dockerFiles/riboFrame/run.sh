#riboFrame only accepts the if there were read1 and read2
fasta=/data/Day1_AERO_Sample02-READ

perl -pi.bak -E 's/^(\@HWI\S+)\s(\d)\S+/$1\/$2/' /data/Day1_AERO_Sample02-READ.1.fastq
perl -pi.bak -E 's/^(\@HWI\S+)\s(\d)\S+/$1\/$2/' /data/Day1_AERO_Sample02-READ.2.fastq
perl -pi.bak -E 's/^(\@HWI\S+)\s(\d)\S+/$1\/$2/' /data/Day1_AERO_Sample02-READ-singleton.fastq

grep -A1 -E "^@.+\/1$" /data/Day1_AERO_Sample02-READ.1.fastq | grep -v -e "--" | sed 's/^@/>/' > /data/Day1_AERO_Sample02-READ.1.fasta
grep -A1 -E "^@.+\/2$" /data/Day1_AERO_Sample02-READ.2.fastq | grep -v -e "--" | sed 's/^@/>/' > /data/Day1_AERO_Sample02-READ.2.fasta
grep -A1 -E "^@.+\/1$" /data/Day1_AERO_Sample02-READ-singleton.fastq  | grep -v -e "--" | sed 's/^@/>/' >> /data/Day1_AERO_Sample02-READ.1.fasta
grep -A1 -E "^@.+\/2$" /data/Day1_AERO_Sample02-READ-singleton.fastq  | grep -v -e "--" | sed 's/^@/>/' >> /data/Day1_AERO_Sample02-READ.2.fasta

hmmsearch -E 0.00001 --domtblout $fasta.1.fwd.bact.ribosomal.table --noali --cpu 12 -o /dev/null hmms/16S_bact_for3.hmm $fasta.1.fasta 
hmmsearch -E 0.00001 --domtblout $fasta.1.rev.bact.ribosomal.table --noali --cpu 12 -o /dev/null hmms/16S_bact_rev3.hmm $fasta.1.fasta 
hmmsearch -E 0.00001 --domtblout $fasta.1.fwd.arch.ribosomal.table --noali --cpu 12 -o /dev/null hmms/16S_arch_for3.hmm $fasta.1.fasta 
hmmsearch -E 0.00001 --domtblout $fasta.1.rev.arch.ribosomal.table --noali --cpu 12 -o /dev/null hmms/16S_arch_rev3.hmm $fasta.1.fasta

hmmsearch -E 0.00001 --domtblout $fasta.2.fwd.bact.ribosomal.table --noali --cpu 6 -o /dev/null hmms/16S_bact_for3.hmm $fasta.2.fasta 
hmmsearch -E 0.00001 --domtblout $fasta.2.rev.bact.ribosomal.table --noali --cpu 6 -o /dev/null hmms/16S_bact_rev3.hmm $fasta.2.fasta 
hmmsearch -E 0.00001 --domtblout $fasta.2.fwd.arch.ribosomal.table --noali --cpu 6 -o /dev/null hmms/16S_arch_for3.hmm $fasta.2.fasta 
hmmsearch -E 0.00001 --domtblout $fasta.2.rev.arch.ribosomal.table --noali --cpu 6 -o /dev/null hmms/16S_arch_rev3.hmm $fasta.2.fasta

perl riboTrap.pl $fasta

java -Xmx1g -jar rdp_classifier-2.3.jar -q $fasta.16S.fasta -o $fasta.16S.rdp

perl riboMap.pl file=$fasta.16S.rdp var=V4 conf=0.8 cross=over percmin=0.5 tol=10% covplot=1 outplot=1 out=$fasta.ab_V4

#all the available reads
#perl riboMap.pl file=$fasta.16S.rdp var=full conf=0.8 cross=over percmin=0.5 covplot=1 outplot=1 out=$fasta.ab_full
#reads falling in all variable regions
#perl riboMap.pl file=$fasta.16S.rdp var=all conf=0.8 cross=over percmin=0.5 tol=10% covplot=1 outplot=1 out=$fasta.ab_all
#reads contained in the V2 and V3 regions with a 10% tolerance
#perl riboMap.pl file=$fasta.16S.rdp var=V2,V3 conf=0.8 cross=over percmin=0.5 tol=10% covplot=1 outplot=1 out=$fasta.ab_V2,V3
#reads mapping from he beginning of the V5 region to the end of the V6 region
#perl riboMap.pl file=samples/SRS011061.16S.rdp var=V5-V6 conf=0.8 cross=over percmin=0.5 tol=10% covplot=1 outplot=1 out=samples/SRS011061.ab_V5-V6
