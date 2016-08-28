#!/usr/bin/env perl

use Modern::Perl '2015';
my %phylum;

while(<>){
    chomp;
    m/"(\S+)"\tphylum/;
    $phylum{$1}++;
}

say "$_\t$phylum{$_}" for keys %phylum
