# syntax=docker/dockerfile:1.3

# Requirements: 
# 'access_token', and 'secret.txt' within the same directory as the Dockerfile

FROM ubuntu:22.04

MAINTAINER Adam Koziol <adam.koziol@inspection.gc.ca>

ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt update -y -qq && apt install -y \
	curl \
	git \
	nano \
	python3-pip \
	wget

# Change dir
WORKDIR /opt

# Install chrome for use with selenium
# Use google-chrome-beta instead of google-chrome-stable, as the latest
# chromedriver version tends to be ahead of the latest google-chrome-stable
# version
RUN wget https://dl.google.com/linux/direct/google-chrome-beta_current_amd64.deb && \
	apt install -y ./google-chrome-beta_current_amd64.deb && \
	rm google-chrome-beta_current_amd64.deb

# Install miniconda
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda.sh && \
	bash /opt/miniconda.sh -b -p /opt/miniconda && \
	rm miniconda.sh

# Add miniconda to PATH
ENV PATH /opt/miniconda/bin:$PATH

# Add conda channels
RUN conda config --add channels Freenome && \
	conda config --add channels conda-forge && \
	conda config --add channels bioconda

# Install mamba
RUN conda install mamba -n base -c conda-forge

# Update conda and mamba
RUN mamba update -n base conda && mamba update -n base mamba

# Install the COWBAT pipeline with mamba
RUN mamba create -n cowbat -c olcbioinformatics -y cowbat=0.5.0.23=py_3

RUN conda init bash

# Set the language to use utf-8 encoding - encountered issues parsing accented
# characters in Mash database
ENV LANG C.UTF-8

# Work-around to get MOB-suite dependencies to work
RUN ln -s /opt/miniconda/envs/cowbat/bin/show-coords /usr/local/bin/show-coords

WORKDIR /home

ENTRYPOINT ["conda", "run", "-n", "cowbat"]