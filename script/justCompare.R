#!/usr/bin/env Rscript

library(data.table)
library(dplyr)
library(magrittr)

rbf         = fread("out/riboFrame/Day1_AERO_Sample02-READ.16S.rdp", h=F, sep="\t")
rbf.phylum  = read.table("out/riboFrame/phylum.count") %>% setNames(c("Phylum", "count")) %>% arrange(count)
rbt         = fread("out/ribotagger/annotation.anno", sep="\t", h=T)
rbt.phylum  = setNames(as.data.frame(table(rbt$p)), c("Phylum", "count")) %>% arrange(count)
rbt.phylum  = rbt.phylum[rbt.phylum$Phylum != "",]
ssu.phylum  = read.csv("out/ssusearch/phylumCount.ssusearch", h=F, sep="\t") %>% setNames(c("Phylum", "count"))
rbfrbt      = merge(rbf.phylum, rbt.phylum, by="Phylum", all=T, suffixes = c(".rbf", ".rbt")) %>% arrange(count.rbt)
rbfrbtssu   = merge(rbfrbt, ssu.phylum, by="Phylum", all=T) %>% setNames(c("Phylum", "count.rbf", "count.rbt", "count.ssu"))
