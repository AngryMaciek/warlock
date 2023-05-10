###############################################################################
#
#   Docker image recipe for containerised warlock analyses
#
#   AUTHOR: Maciek Bak
#   CONTACT: wsciekly.maciek@gmail.com
#
###############################################################################

##### BASE IMAGE #####
FROM continuumio/miniconda3:23.3.1-0

##### METADATA #####
LABEL base.image="continuumio/miniconda3:23.3.1-0"
LABEL version="1.0.0"
LABEL software="warlock"
LABEL software.version="$(cat VERSION)"
LABEL software.description="Warlock is a snakemake workflow to spawn multiple demons (deme-based oncology models)."
LABEL software.website="https://github.com/AngryMaciek/warlock"
LABEL software.license="Apache-2.0"
LABEL software.tags="Computational Biology, Mathematical Oncology, Snakemake"
LABEL maintainer="Maciek Bak"
LABEL maintainer.email="wsciekly.maciek@gmail.com"
LABEL maintainer.organisation="City, University of London"

##### ENVIROMENTAL VARIABLES #####
ENV LANG C.UTF-8
ENV SHELL /bin/bash

##### COPY REPOSITORY #####
WORKDIR warlock
COPY . .

RUN apt-get update && apt-get upgrade -y \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

##### INSTALL MAMBA + BUILD CONDA ENV #####
RUN \
  conda install mamba -c conda-forge --yes \
  && mamba env create --file environment.yml \
  && conda clean --all --yes \
  && echo "conda activate warlock" >> ~/.bashrc

##### COMPILE DEMON #####
RUN \
  /opt/conda/envs/warlock/bin/g++ \
  resources/demon_model/src/demon.cpp \
  -o resources/demon_model/bin/demon \
  -I /opt/conda/envs/warlock/include \
  -lm
