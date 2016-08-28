############################################################
# Dockerfile for running SSUsearch
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu which is 16.04 at the time of writing this
FROM ubuntu:latest

# File Author / Maintainer
MAINTAINER Wesley GOI <wesley@bic.nus.edu.sg>

# Update the repository sources list
RUN apt-get update --fix-missing && apt-get install -y perl unzip wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

ENV SHELL=/bin/bash

# mount testing fasta file dataset

RUN mkdir /compare
RUN git clone https://github.com/xiechaos/ribotagger.git /compare/ribotagger

RUN mkdir -p /compare/ribotagger/misc/dict.builder/data/silva.119/raw/taxonomy/

WORKDIR /compare/ribotagger/misc/dict.builder/data/silva.119/raw/taxonomy/
RUN apt-get install -y curl
RUN curl -O https://www.arb-silva.de/fileadmin/silva_databases/release_119/Exports/taxonomy/tax_slv_ssu_nr_119.txt

WORKDIR /compare/ribotagger/misc/dict.builder/data/
RUN wget https://www.arb-silva.de/fileadmin/silva_databases/release_119/Exports/SILVA_119_SSURef_tax_silva.fasta.gz && \
    gunzip SILVA_119_SSURef_tax_silva.fasta.gz

COPY convert2dna.pl /compare/ribotagger/misc/dict.builder/data/convert2dna.pl

RUN apt-get install -y bioperl
RUN perl convert2dna.pl SILVA_119_SSURef_tax_silva.fasta

COPY silva.dict.sh /compare/ribotagger/misc/dict.builder/

WORKDIR /compare/ribotagger/misc/dict.builder/
RUN mkdir -p ./script/dict.builder/
RUN mkdir -p dict/raw/ script/dict script/dict.builder
RUN cp /compare/ribotagger/ribotagger/ribotagger.pl /compare/ribotagger/misc/dict.builder/script/ribo.pl
COPY silva.pl /compare/ribotagger/misc/dict.builder/script/dict.builder/silva.pl
RUN cp lite.pl /compare/ribotagger/misc/dict.builder/script/dict.builder

VOLUME /data
apt-get install bc
