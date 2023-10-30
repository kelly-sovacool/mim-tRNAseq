FROM nciccbr/ccbr_ubuntu_base_20.04:v6

RUN apt-get update && apt-get install -y libffi-dev libdeflate-dev libsqlite3-dev libcurl4-openssl-dev

# install python 3.7 & local mimseq
COPY . /opt2/mim-tRNAseq
WORKDIR /opt2/mim-tRNAseq
RUN mamba create -n py37 -c conda-forge python=3.7 && \
  mamba activate py37 && \
  python3.7 -m pip install . --upgrade && \
  mimseq --version

# check mimseq installation
RUN which mimseq && mimseq --version

# install usearch
WORKDIR /opt2
RUN wget https://drive5.com/downloads/usearch10.0.240_i86linux32.gz && \
        gunzip usearch10.0.240_i86linux32.gz && \
        chmod a+x usearch10.0.240_i86linux32 && \
        mkdir -p /opt2/usearch && \
        mv usearch10.0.240_i86linux32 /opt2/usearch/usearch && \
        rm -f usearch10.0.240_i86linux32.gz
ENV PATH=/opt2/usearch:$PATH


# cleanup
RUN apt-get clean && apt-get purge && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

COPY Dockerfile /opt2/Dockerfile
RUN chmod -R a+rX /opt2/Dockerfile

WORKDIR /data2
