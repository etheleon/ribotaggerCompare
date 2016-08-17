############################################################
# Dockerfile for running SSUsearch
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu
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

RUN wget http://eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz && \
    tar -xzvf hmmer-3.1b2.tar.gz

WORKDIR hmmer-3.1b2

RUN ./configure && \
    make && \
    make install

ENV PATH /opt/conda/bin:/usr/local/bin:$PATH

RUN conda install -c ged screed=0.7.1

WORKDIR /

RUN wget http://www.mothur.org/w/images/8/88/Mothur.cen_64.zip -O mothur.zip && \
    unzip mothur.zip

ENV PATH /mothur/:$PATH

RUN conda install jupyter

EXPOSE 8888

COPY run_ipython.sh /run_ipython.sh
RUN chmod +x /run_ipython.sh

RUN mkdir -p /notebooks
VOLUME /notebooks

ENV SHELL=/bin/bash
CMD ["/run_ipython.sh"]
