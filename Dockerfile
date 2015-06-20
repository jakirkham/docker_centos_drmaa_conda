FROM centos:6.6
MAINTAINER John Kirkham <jakirkham@gmail.com>


RUN echo "root:docker" | chpasswd

RUN echo "exclude=*.i386 *.i686" >> /etc/yum.conf && \
    yum update -y && \
    yum install -y sudo && \
    yum clean all

RUN groupadd -f wheel && \
    useradd -m -s /bin/bash -g wheel user && \
    echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

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

ENTRYPOINT [ "/usr/share/docker/docker_entrypoint.sh" ]
CMD [ "/bin/bash" ]
