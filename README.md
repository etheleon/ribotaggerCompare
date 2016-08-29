## Comparison for Ribotagger against other softwares

For each of the methods:

1. [Ribotagger](https://github.com/xiechaos/ribotagger)
2. [RiboFrame](bioserver2.sbsc.unifi.it/bioinfo/riboframe.html)
3. [SSUsearch](https://github.com/dib-lab/SSUsearch)

We ran the benchmark inside an isolated docker container in a Ubuntu 16.04 environment. 
The Dockerfiles can be found under `script/dockerFiles/<name of method>/Dockerfile` together with the necessary miscellaneous scripts.

```
script/dockerFiles/
|-- riboFrame
|   |-- Dockerfile
|   `-- run.sh
|-- ribotagger
|   |-- Dockerfile
|   |-- convert2dna.pl
|   |-- silva.dict.sh
|   `-- silva.pl
`-- ssusearch
    |-- Dockerfile
        `-- runTest.sh
```

To learn how to run Docker please refer to this [link](https://docs.docker.com/docker-for-mac/)

