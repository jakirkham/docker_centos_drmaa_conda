#!/bin/bash

# Install curl to download the miniconda setup script.
yum install -y curl

# Install bzip2.
yum install -y bzip2 tar

# Install dependencies of conda's Qt4.
yum install -y libSM libXext libXrender

# Clean out yum.
yum clean all

# Download and configure conda.
cd /usr/share/miniconda
curl http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh > miniconda.sh
bash miniconda.sh -b -p /opt/conda
export PATH="/opt/conda/bin:${PATH}"
source activate root

# Install basic conda dependencies.
conda update -y --all
conda install -y conda-build
conda install -y binstar
conda install -y jinja2
