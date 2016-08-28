#!/usr/bin/env perl

use Bio::SeqIO;

my $in = Bio::SeqIO->new(-file => $ARGV[0], -format => 'fasta');
my $out = Bio::SeqIO->new(-file => '>output.fna', -format => 'fasta');

while(my $seq = $in->next_seq){
    my $theSeq = $seq->seq();
    $theSeq =~ tr/AUCGaucg/ATCGatcg/;
    $seq->seq($theSeq);
    $out->write_seq($seq);
}
