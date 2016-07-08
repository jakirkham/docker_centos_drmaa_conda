#!/bin/bash

# Update yum.
yum update -y -q

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

# Install everything for both environments.
export OLD_PATH="${PATH}"
for PYTHON_VERSION in 2 3;
do
    export CONDA_PATH="/opt/conda${PYTHON_VERSION}"

    # Download and install `conda`.
    cd /usr/share/miniconda
    curl "http://repo.continuum.io/miniconda/Miniconda${PYTHON_VERSION}-latest-Linux-x86_64.sh" > "miniconda${PYTHON_VERSION}.sh"
    bash "miniconda${PYTHON_VERSION}.sh" -b -p "${CONDA_PATH}"
    rm "miniconda${PYTHON_VERSION}.sh"

    # Configure `conda` and add to the path
    export PATH="${CONDA_PATH}/bin:${OLD_PATH}"
    source activate root
    conda config --set show_channel_urls True

    # Update and install basic conda dependencies.
    conda update -y --all
    conda install -y pycrypto
    conda install -y conda-build
    conda install -y anaconda-client
    conda install -y jinja2

    # Install python bindings to DRMAA.
    conda install -y drmaa

    # Clean out all unneeded intermediates.
    conda clean -yitps

    # Provide links in standard path.
    ln -s "${CONDA_PATH}/bin/python"  "/usr/local/bin/python${PYTHON_VERSION}"
    ln -s "${CONDA_PATH}/bin/pip"  "/usr/local/bin/pip${PYTHON_VERSION}"
    ln -s "${CONDA_PATH}/bin/conda"  "/usr/local/bin/conda${PYTHON_VERSION}"
done

# Set the conda2 environment as the default.
# This should be removed in the future.
ln -s /opt/conda2 /opt/conda
