############################################################
# Dockerfile for running SSUsearch
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu which is 16.04 at the time of writing this
FROM ubuntu:latest

# File Author / Maintainer
MAINTAINER Wesley GOI <wesley@bic.nus.edu.sg>

# Update the repository sources list
RUN apt-get update --fix-missing && apt-get install -y openjdk-7-jre-headless perl unzip wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget https://repo.continuum.io/archive/Anaconda2-4.1.1-Linux-x86_64.sh --no-check-certificate -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt-get update -qq
RUN apt-get install -qq gcc-4.9 g++-4.9 build-essential
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 90
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 90
RUN update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-4.9 90

# Dependency-HMMER
RUN wget http://eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz && \
    tar -xzvf hmmer-3.1b2.tar.gz
WORKDIR hmmer-3.1b2
RUN ./configure && \
    make && \
    make install

ENV PATH /opt/conda/bin:/usr/local/bin:$PATH
RUN conda install -c ged screed=0.7.1

WORKDIR /

# Dependency-Mothur
RUN wget http://www.mothur.org/w/images/8/88/Mothur.cen_64.zip -O mothur.zip && \
    unzip mothur.zip
ENV PATH /mothur/:$PATH

# For hosting jupyter notebook
# RUN conda install jupyter

# EXPOSE 8888
# COPY run_ipython.sh /run_ipython.sh
# RUN chmod +x /run_ipython.sh

# RUN mkdir -p /notebooks
# VOLUME /notebooks

ENV SHELL=/bin/bash

# mount testing fasta file dataset

RUN mkdir -p /compare/SSUsearch /compare/ribotagger /compare/workdir /compare/data
RUN git clone https://github.com/dib-lab/SSUsearch.git /compare/SSUsearch
# Necesary HMM files

WORKDIR /compare/data
RUN curl -O curl -O https://s3.amazonaws.com/ssusearchdb/SSUsearch_db.tgz && \
    tar zvxf SSUsearch_db.tgz

# test files - not neccessary to run
RUN wget https://s3.amazonaws.com/ssusearchdb/test.tgz &&\
    tar zvxf test.tgz

WORKDIR /compare

RUN apt-get install -y bc

COPY runTest.sh /compare
VOLUME /data
# CMD ["/run_ipython.sh"]
