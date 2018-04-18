FROM jakirkham/centos_conda:latest
MAINTAINER John Kirkham <jakirkham@gmail.com>

ADD gridengine /usr/share/gridengine
RUN /usr/share/gridengine/install_ge.sh

ENV SGE_CONFIG_DIR=/usr/share/gridengine \
    SGE_ROOT=/usr/share/gridengine \
    SGE_CELL=default \
    DRMAA_LIBRARY_PATH=/usr/lib64/libdrmaa.so.1.0

RUN for PYTHON_VERSION in 2 3; do \
        export INSTALL_CONDA_PATH="/opt/conda${PYTHON_VERSION}" && \
        . ${INSTALL_CONDA_PATH}/bin/activate && \
        conda install -qy drmaa && \
        conda clean -tipsy && \
        . ${INSTALL_CONDA_PATH}/bin/deactivate && \
        rm -rf ~/.conda ; \
    done

ADD entrypoint.sh /usr/share/docker/entrypoint_2.sh

ENTRYPOINT [ "/opt/conda/bin/tini", "--", "/usr/share/docker/entrypoint.sh", "/usr/share/docker/entrypoint_2.sh" ]
CMD [ "/bin/bash" ]
