FROM nciccbr/ccbr_ubuntu_base_20.04:v6

RUN mkdir -p /opt2 && mkdir -p /data2
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt-get -y upgrade
# Set the locale
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	locales build-essential cmake cpanminus && \
	localedef -i en_US -f UTF-8 en_US.UTF-8 && \
	cpanm FindBin Term::ReadLine

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	g++ \
	gcc \
	libatlas-base-dev \
	libblas-dev \
	libboost-dev \
	libbz2-dev \
	libcurl4-openssl-dev \
  libdeflate-dev \
	libexpat1-dev \
  libffi-dev \
	libfreetype6-dev \
	libgd-dev \
	libgs-dev \
	libgsl-dev \
	libgsl0-dev \
	libicu-dev \
	libjudy-dev \
	liblapack-dev \
	liblzma-dev \
	libmysqlclient-dev \
	libncurses-dev \
	libopenmpi-dev \
	libpng-dev \
	librtmp-dev \
	libssl-dev \
  libsqlite3-dev \
	libtool \
	libxml2-dev \
	libxslt-dev \
	make \
	manpages-dev \
  pigz \
	python3.7-pip \
  python3.7-dev \
	rsync \
	unzip \
	wget \
	zlib1g \
	zlib1g-dev \
	zlibc 

# need python3.7 for mimseq
RUN ln -s /usr/bin/python3.7 /usr/bin/python

# install usearch
WORKDIR /opt2
RUN wget https://drive5.com/downloads/usearch10.0.240_i86linux32.gz && \
        unpigz usearch10.0.240_i86linux32.gz && \
        chmod a+x usearch10.0.240_i86linux32 && \
        mkdir -p /opt2/usearch && \
        mv usearch10.0.240_i86linux32 /opt2/usearch/usearch && \
        rm -f usearch10.0.240_i86linux32.gz
ENV PATH=/opt2/usearch:$PATH

# install local mimseq
RUN python -m pip install --upgrade pip && \
	pip install .

# check mimseq installation
RUN which mimseq && mimseq --help

# cleanup
RUN apt-get clean && apt-get purge && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

COPY Dockerfile /opt2/Dockerfile
RUN chmod -R a+rX /opt2/Dockerfile

WORKDIR /data2
