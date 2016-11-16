#!/bin/bash

set -e

# Update yum.
yum update -y -q

# Install curl to download the miniconda setup script.
yum install -y -q curl

# Install bzip2.
yum install -y -q bzip2 tar

# Install dependencies of conda's Qt4.
yum install -y -q libSM libXext libXrender

# Clean out yum.
yum clean all -y -q

# Install everything for both environments.
export OLD_PATH="${PATH}"
for PYTHON_VERSION in 2 3;
do
    export INSTALL_CONDA_PATH="/opt/conda${PYTHON_VERSION}"

    # Download and install `conda`.
    cd /usr/share/miniconda
    curl "http://repo.continuum.io/miniconda/Miniconda${PYTHON_VERSION}-latest-Linux-x86_64.sh" > "miniconda${PYTHON_VERSION}.sh"
    bash "miniconda${PYTHON_VERSION}.sh" -b -p "${INSTALL_CONDA_PATH}"
    rm "miniconda${PYTHON_VERSION}.sh"

    # Configure `conda` and add to the path
    export PATH="${INSTALL_CONDA_PATH}/bin:${OLD_PATH}"
    source activate root
    conda config --set show_channel_urls True

    # Add conda-forge to our channels.
    conda config --add channels conda-forge

    # Pin `conda-build` until `bdist_conda` works.
    # Please see the linked issue.
    #
    # https://github.com/conda/conda-build/issues/1305
    #
    touch "${INSTALL_CONDA_PATH}/conda-meta/pinned"
    echo "conda-build 1.*" >> "${INSTALL_CONDA_PATH}/conda-meta/pinned"

    # Update and install basic conda dependencies.
    conda update -qy --all
    conda install -qy pycrypto
    conda install -qy conda-build
    conda install -qy anaconda-client
    conda install -qy jinja2

    # Install python bindings to DRMAA.
    conda install -qy drmaa

    # Install common VCS packages.
    conda install -qy git
    conda install -qy mercurial
    conda install -qy svn

    # Clean out all unneeded intermediates.
    conda clean -tipsy

    # Provide links in standard path.
    ln -s "${INSTALL_CONDA_PATH}/bin/python"  "/usr/local/bin/python${PYTHON_VERSION}"
    ln -s "${INSTALL_CONDA_PATH}/bin/pip"  "/usr/local/bin/pip${PYTHON_VERSION}"
    ln -s "${INSTALL_CONDA_PATH}/bin/conda"  "/usr/local/bin/conda${PYTHON_VERSION}"
done

# Set the conda2 environment as the default.
# This should be removed in the future.
ln -s /opt/conda2 /opt/conda
