# Copyright (c) 2019 Steven R. Brandt, and Roland Haas
#
# Distributed under the LGPL

# It is possible to use a later version of Ubuntu,
# however, if one does that then a Singularity version
# of the image will not run on Shelob and other clusters
# with older linux kernels.
FROM ubuntu:20.04

USER root
ENV PYVER 3.8
ENV DEBIAN_FRONTEND=noninteractive

# Update per release
ENV ET_RELEASE ET_2023_05
ENV KUIBIT_RELEASE 1.4.0

# Including --no-install-recommends does help optimize
# the size of the image, but it makes it much harder to
# get the list of packages right. This list works.
RUN apt-get -qq update && \
    apt-get -qq install --no-install-recommends locales locales-all \
        g++-10 python${PYVER} python3-pip gfortran-10 make git m4 patch \
        subversion wget curl gnuplot gnuplot-x11 time libopenmpi-dev \
        libhdf5-openmpi-dev procps unzip mercurial file libmkl-dev \
        libnuma-dev numactl hwloc libhwloc-dev libssl-dev python3-pyudev libudev-dev \
        hdf5-tools gdb gsl-bin libgsl0-dev python3-setuptools cmake libboost-dev \
        ffmpeg imagemagick libgsl-dev libopenblas-dev libpapi-dev fftw3-dev \
        liblapack-dev vim emacs nano openssh-client pkg-config libpmi0 \
        libpython${PYVER}-dev libpython${PYVER}-dbg rsync vim nano \
        libscalapack-openmpi-dev \
        libpmi1-pmix libpmi2-pmix libpmix-dev libpmix2 libopenmpi-dev libopenmpi3 libpmi-pmix-dev && \
    apt-get -qq clean all && \
    apt-get -qq autoclean && \
    apt-get -qq autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates
#- update /etc/ssl/certs and ca-certificates.crt

#RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
RUN rm -f /usr/bin/cpp
RUN update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-10 10
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10
RUN update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-10 10

# It is possible to install matplotlib and numpy using
# apt, unfortunately, one cannot install jupyter that
# way and the matplotlib builtin to ubuntu's apt system
# does not seem to work with jupyter. Numpy may not
# be needed, but if the users want to do any analysis
# in the notebook beyond following the script, they'll
# want to have it.
# pick jpupyterhub to match that of kubernetes jupyterhub chart which in its
# version 0.7.0 uses version 0.9.2 of jupyterhub
# this version requires python3
RUN pip3 install jupyter \
    jupyterhub \
    matplotlib \
    numpy \
    scipy \
    h5py \
    scrolldown \
    dumb-init \
    celluloid

COPY build-cactus-tarball.sh /usr/local/bin/build-cactus-tarball.sh
RUN useradd -m etuser -u 10000 -d /usr/etuser
USER etuser
WORKDIR /usr/etuser

# Until the defs get added to simfactory
COPY sim.tgz /usr/etuser/

RUN bash /usr/local/bin/build-cactus-tarball.sh
USER root

WORKDIR /

ENV PKG_CONFIG_PATH /usr/share/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/pkgconfig

RUN python3 -m pip install scons termcolor kuibit==${KUIBIT_RELEASE} mpld3 clang_format sympy nrpylatex core-watpy
RUN apt-get update -y
RUN apt-get install -y pgplot5 

RUN mkdir -p /jupyter-et && chmod 755 /jupyter-et
COPY Initial_Data.tgz /usr/local/data/

### CarpetX stuff

RUN apt install -y libhdf5-dev

# Install cmake
# We need a modern cmake to build AMReX
RUN mkdir dist && \
    (cd dist && \
    wget https://github.com/Kitware/CMake/releases/download/v3.21.2/cmake-3.21.2-linux-x86_64.tar.gz && \
    tar xzf cmake-3.21.2-linux-x86_64.tar.gz && \
    rsync -r cmake-3.21.2-linux-x86_64/ /usr/local && \
    true) && \
    rm -rf dist

# Install ADIOS2
# ADIOS2 is a parallel I/O library, comparable to HDF5
RUN mkdir src && \
    (cd src && \
    wget https://github.com/ornladios/ADIOS2/archive/refs/tags/v2.9.0.tar.gz && \
    tar xzf v2.9.0.tar.gz && \
    cd ADIOS2-2.9.0 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    true) && \
    rm -rf src

# Install NSIMD
# NSIMD allows writing explicitly SIMD-vectorized code
# Note: This assumes that the system has x86_64 CPUs
RUN mkdir src && \
    (cd src && \
    wget https://github.com/agenium-scale/nsimd/archive/refs/tags/v3.0.1.tar.gz && \
    tar xzf v3.0.1.tar.gz && \
    cd nsimd-3.0.1 && \
    mkdir build && \
    cd build && \
    cmake \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DCMAKE_C_COMPILER=gcc \
        -DCMAKE_CXX_COMPILER=g++ \
        -Dsimd=SSE2 \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        .. && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    true) && \
    rm -rf src

RUN apt install -y libpython3-dev

# Install openPMD-api
# openPMD-api defines a standard for laying out AMR data in a file
# - Depends on ADIOS2
RUN mkdir src && \
    (cd src && \
    wget https://github.com/openPMD/openPMD-api/archive/refs/tags/0.15.1.tar.gz && \
    tar xzf 0.15.1.tar.gz && \
    cd openPMD-api-0.15.1 && \
    mkdir build && \
    cd build && \
    cmake -DopenPMD_USE_PYTHON=python .. && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    true) && \
    rm -rf src

# Install ssht
# ssht provides spin-weighted spherical harmonics
RUN mkdir src && \
    (cd src && \
    wget https://github.com/astro-informatics/ssht/archive/v1.5.1.tar.gz && \
    tar xzf v1.5.1.tar.gz && \
    cd ssht-1.5.1 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    true) && \
    rm -rf src

# Install Silo
# openPMD-api defines a standard for laying out AMR data in a file
RUN mkdir src && \
    (cd src && \
    wget https://github.com/LLNL/Silo/releases/download/v4.11/silo-4.11.tar.gz && \
    tar xzf silo-4.11.tar.gz && \
    cd silo-4.11 && \
    mkdir build && \
    cd build && \
    ../configure \
        --disable-fortran \
        --enable-optimization \
        --with-hdf5=/usr/lib/x86_64-linux-gnu/hdf5/serial/include,/usr/lib/x86_64-linux-gnu/hdf5/serial/lib \
        --prefix=/usr/local && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    true) && \
    rm -rf src

# Install yaml-cpp
# yaml-cpp allows reading and writing YAML files
RUN mkdir src && \
    (cd src && \
    wget https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.3.tar.gz && \
    tar xzf yaml-cpp-0.6.3.tar.gz && \
    cd yaml-cpp-yaml-cpp-0.6.3 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    true) && \
    rm -rf src

ARG real_precision=real64

# Install AMReX
# AMReX provides adaptive mesh refinement
# - Enable Fortran for `docker/Dockerfile`
# - Install this last because it changes most often
# Should we  keep AMReX source tree around for debugging?
RUN mkdir src && \
    (cd src && \
    wget https://github.com/AMReX-Codes/amrex/archive/23.05.tar.gz && \
    tar xzf 23.05.tar.gz && \
    cd amrex-23.05 && \
    mkdir build && \
    cd build && \
    case $real_precision in \
        real32) precision=SINGLE;; \
        real64) precision=DOUBLE;; \
        *) exit 1;; \
    esac && \
    cmake \
        -DAMReX_OMP=ON \
        -DAMReX_PARTICLES=ON \
        -DAMReX_PRECISION="$precision" \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        .. && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    true) && \
    rm -rf src

RUN apt install -y libgsl-dev
RUN apt install -y libboost-all-dev
USER etuser
WORKDIR /usr/etuser
# COPY carpetx.th ./
RUN curl -LO https://raw.githubusercontent.com/jaykalinani/AsterX/ETX_2023_06/Docs/thornlist/asterx.th
COPY carpetx.cfg ./
COPY build-carpetx.sh ./
RUN bash ./build-carpetx.sh
WORKDIR /usr/etuser/CarpetX
COPY make-tarball.sh /usr/local/bin/
RUN bash /usr/local/bin//make-tarball.sh
USER root
RUN mkdir -p /home/root
RUN perl -p -i -e 's{:/root:}{:/home/root:}' /etc/passwd
RUN apt update -y && apt install munge mariadb-server git-lfs libscalapack-openmpi-dev -y
WORKDIR /etc/skel
RUN git clone https://github.com/GRChombo/engrenage.git && rm -fr engrenage/.git
RUN mkdir -p /tutorial && chmod 755 /tutorial
COPY notebooks/*.ipynb /tutorial/
RUN chmod og+r /tutorial/* /etc/skel/* /usr/local/data/Initial_Data.tgz
COPY core-gitlfs-tpi-uni-jena-de.pem /etc/certs/
COPY notebooks/*.ipynb /etc/skel/
COPY et-setup.py /usr/local/lib/
WORKDIR /etc/skel/CoReDB_tutorial
COPY CoReDB_tutorial/watpy_CoReDB.ipynb ./
WORKDIR /etc/skel/CoReDB_tutorial/MySim_THC_135135
COPY CoReDB_tutorial/MySim_THC_135135/mp_Psi4* ./
WORKDIR /etc/skel
RUN find . -type f | xargs chmod og+r 
RUN find . -type d | xargs chmod og+rx
#COPY sssd.conf.sh /usr/local/bin/
#RUN echo services: files sss >> /etc/nsswitch.conf
RUN apt install sudo -y && useradd -m admin -s /usr/bin/bash -d /home/admin && adduser admin sudo && echo "admin     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
COPY start-ldap.sh /usr/local/bin/
