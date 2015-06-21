FROM centos:6.6
MAINTAINER John Kirkham <jakirkham@gmail.com>


RUN echo "exclude=*.i386 *.i686" >> /etc/yum.conf && \
    yum update -y && \
    yum clean all

ADD gridengine /usr/share/gridengine
RUN /usr/share/gridengine/install_ge.sh

ENV SGE_CONFIG_DIR=/usr/share/gridengine \
    SGE_ROOT=/usr/share/gridengine \
    SGE_CELL=default \
    DRMAA_LIBRARY_PATH=/usr/lib64/libdrmaa.so.1.0

ADD miniconda /usr/share/miniconda
RUN /usr/share/miniconda/install_miniconda.sh

ENV PATH=/opt/conda/bin:$PATH

ADD docker /usr/share/docker

ENTRYPOINT [ "/usr/share/docker/entrypoint.sh" ]
CMD [ "/bin/bash" ]
