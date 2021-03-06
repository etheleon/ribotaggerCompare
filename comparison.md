## Benchmarking Ribotagger

We compare the following competing softwares against [Ribotagger](github.com/xiechaos/ribotagger) using a [common dataset - Anoxic aerobic tanks from Ulu Pandan wastewater treatment plant ](/raid/home/wesley/github/compareRibo/data) for the V4 region.

1. SSUSearch - Microbial community analysis with ribosomal gene fragments from shotgun metagenomes (Guo et al 2016)
    * [Pubmed](http://www.ncbi.nlm.nih.gov/pubmed/26475107)
    * [Software](https://github.com/dib-lab/SSUsearch)
2. riboFrame from Ramazzotti et al 2015
    * [Pubmed](http://www.ncbi.nlm.nih.gov/pubmed/26635865)
    * [Software](https://github.com/matteoramazzotti/riboFrame)

others (but not investigated)
* Metaxa and Metaxa2. Work from Bentsson et al. 
    * [Pubmed - Metaxa](http://www.ncbi.nlm.nih.gov/pubmed/21674231)
    * [Pubmed - Metaxa2 Bengtsson-Palme et al. 2015](http://www.ncbi.nlm.nih.gov/pubmed/25732605)
    * [Software](http://microbiology.se/software/metaxa2/)


### Preprocessing

* Fastqc
* Reads have been trimmed using trimmomatic (adapter and quality trimmed)


## Hardware Specs:

Domain name: wesley@r810.bic.nus.edu.sg

| Component | Specs |
| --- | --- |
| CPU | 2 x Intel Xeon X7542 (18M Cache, 2.66 GHz)
| RAM | 128 GB memory |
| HDD | 146 GB OS disk (usable 104 GB) |
| EXTERNAL HDD |  8 TB RAID disk (usable 7.3 TB) |

## Software OS Environment

We tested the softwares using a Ubuntu 16.04 docker container.
The dockerfiles for the environments are provided in the project `script/dockerFiles` directory

#### Ribotagger (silva db v119)


```
START=$(date +%s.%N)
./ribotagger/ribotagger.pl -r v4 -i /data/Day1_AERO_Sample02-combined.fasta -o out/Day1_AERO_Sample02-combined.v4
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
```

Time taken: 5833.596518936

#### SSUSearch

#not accurate (the HDD ran out of space before the job completed)


```
START=$(date +%s.%N)
bash runTest.sh
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
```


Time Taken: around 7 hours (31988)

__Comments__

* Option to upgrade the database is not available
    * Gathering of the Database files is not automated and requires substantial time and effort
* Scripts necessary for the reconstruction of the HMMs are not included in the pipeline (silva 115 - 06 March 2015)
* __SSUSearch__ is written as a click and run pipeline and requires multiple steps while __Ribotagger__ is written as a single click software.

#### RiboFrame


```
START=$(date +%s.%N)
./run.sh
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
```

Time taken: 20405.431670749


```r
library(data.table)
library(dplyr)
library(magrittr)
library(ggplot2)

#rbf         = fread("../out/riboFrame/Day1_AERO_Sample02-READ.16S.rdp", h=F, sep="\t")
rbf.phylum  = read.table("../out/riboFrame/phylum.count") %>% setNames(c("Phylum", "count")) %>% arrange(count)
rbt         = fread("../out/ribotagger/annotation.anno", sep="\t", h=T)
rbt.countFile = fread("../out/ribotagger/annotation.tab", sep="\t", h=T) %>% setNames(c("tag", "count"))
rbtNEW = merge(rbt, rbt.countFile, by="tag", all=T)
rbt.phylum = rbtNEW %>% select(p, count) %>% group_by(p) %>% summarise(counts = sum(count)) %>% setNames(c("Phylum", "count"))

#rbt.phylum  = setNames(as.data.frame(table(rbt$p)), c("Phylum", "count")) %>% arrange(count)
#rbt.phylum  = rbt.phylum[rbt.phylum$Phylum != "",]

ssu.phylum  = read.csv("../out/ssusearch/phylumCount.ssusearch", h=F, sep="\t") %>% setNames(c("Phylum", "count"))
rbfrbt      = merge(rbf.phylum, rbt.phylum, by="Phylum", all=T, suffixes = c(".rbf", ".rbt")) %>% arrange(count.rbt)
rbfrbtssu   = merge(rbfrbt, ssu.phylum, by="Phylum", all=T) %>% setNames(c("Phylum", "count.rbf", "count.rbt", "count.ssu"))
rbfrbtssu[is.na(rbfrbtssu)] = 0

rbfrbtssu %$% qplot(log10(count.rbt+1), log10(count.ssu+1)) 
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png) 

```r
rbfrbtssu %$% qplot(log10(count.rbf+1),  log10(count.ssu+1))
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-2.png) 

```r
rbfrbtssu %$% qplot(log10(count.rbf+1), log10(count.rbt+1))
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-3.png) 





