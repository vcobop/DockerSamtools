FROM ubuntu:22.04

LABEL maintainer="Valentina Cobo Paz <valentinacobopaz@gmail.com>"

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package manager and install dependencies required for HTSlib
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    bzip2 \
    libncurses5-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src

# Define the Samtools version to install
ARG SAMTOOLS_VERSION=1.23.1

# Download, extract, compile, install, and clean up in a single layer
RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    tar jxf samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    rm samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd samtools-${SAMTOOLS_VERSION} && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf samtools-${SAMTOOLS_VERSION}


