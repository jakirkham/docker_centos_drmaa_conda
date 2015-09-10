#!/bin/bash

# Install curl to download the miniconda setup script.
yum install -y curl

# Install VCS.
yum install -y git hg svn

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
conda config --set show_channel_urls True

# Install basic conda dependencies.
conda update -y --all
conda install -y pycrypto
conda install -y conda-build
conda install -y anaconda-client
conda install -y jinja2

# Install drmaa to provide Python support for DRMAA.
conda install -y drmaa

# Clean out all unneeded intermediates.
conda clean -yitps
