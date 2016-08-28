#!/usr/bin/env perl

use Modern::Perl '2015';
my %phylum;

while(<>){
    chomp;
    m/^Bacteria;([^;]+)\S+\s(\d+)/;
    if(exists $phylum{$1}){ 
        $phylum{$1} =  $phylum{$1} + $2;
    }else{
        $phylum{$1} = $2;
    }
}
say "$_\t$phylum{$_}" for keys %phylum;


#cat ../out/ssusearch/Day1_AERO_Sample02-combined.qc.ssu.align.filter.wang.silva.taxonomy.count | ./parseCount.pl > ../out/ssusearch/phylumCount.ssusearch
