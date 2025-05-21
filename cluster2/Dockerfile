FROM ubuntu:22.04

USER root
ENV PYVER 3.11
ENV DEBIAN_FRONTEND=noninteractive

# Update per release
ENV ET_RELEASE ET_2024_11
ENV KUIBIT_RELEASE 1.4.0

# Including --no-install-recommends does help optimize
# the size of the image, but it makes it much harder to
# get the list of packages right. This list works.
RUN apt-get -qq update && \
    apt-get -qq install --no-install-recommends locales locales-all \
        g++ python${PYVER} python3-pip gfortran make git m4 patch \
        subversion wget curl gnuplot gnuplot-x11 time \
        procps unzip mercurial file libmkl-dev \
        libnuma-dev numactl hwloc libhwloc-dev libssl-dev python3-pyudev libudev-dev \
        gdb gsl-bin libgsl0-dev python3-setuptools cmake libboost-dev \
        ffmpeg imagemagick libgsl-dev libopenblas-dev libpapi-dev fftw3-dev \
        liblapack-dev vim emacs nano openssh-client pkg-config \
        libpython${PYVER}-dev libpython${PYVER}-dbg rsync vim nano \
        apt-file lbzip2 xz-utils pgplot5

RUN update-ca-certificates

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.11 10
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/python3.11 10
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 10
RUN update-alternatives --install /usr/bin/pip3 pip3 /usr/bin/python3.11 10

# It is possible to install matplotlib and numpy using
# apt, unfortunately, one cannot install jupyter that
# way and the matplotlib builtin to ubuntu's apt system
# does not seem to work with jupyter. Numpy may not
# be needed, but if the users want to do any analysis
# in the notebook beyond following the script, they'll
# want to have it.
RUN pip3 install jupyter \
    matplotlib \
    numpy \
    scipy \
    h5py \
    dumb-init \
    celluloid \
    kuibit \
    termcolor \
    scons \
    clang_format \
    mpld3 \
    sympy \
    nrpylatex \
    nrpy==2.0.18 \
    core-watpy \
    multimethod \
    pdoc \
    oauthenticator==15.1.0 \
    jupyterhub==4.1.5

RUN useradd -m etuser -u 10000 -d /usr/etuser
USER etuser
WORKDIR /usr/etuser
USER root

WORKDIR /

ENV PKG_CONFIG_PATH /usr/share/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/pkgconfig

#RUN python3 -m pip install scons termcolor kuibit==${KUIBIT_RELEASE} mpld3 clang_format sympy nrpylatex core-watpy

RUN mkdir -p /jupyter-et && chmod 755 /jupyter-et
#COPY Initial_Data.tgz /usr/local/data/

# Install dependencies with Spack
ENV SPACK_SKIP_MODULES 1
ENV SPACK_ROOT /usr/spack-root
ENV PATH $SPACK_ROOT/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

COPY spack-setup.sh .
RUN chmod 755 spack-setup.sh
RUN ./spack-setup.sh

RUN ${SPACK_ROOT}/bin/spack external find --not-buildable perl diffutils findutils tar pkgconf fortran

ENV AMREX_VER 25.02 +shared +particles build_type=RelWithDebInfo +openmp

ENV BASE=/usr
ENV SPACK_ENV_NAME=cactus-tutorial
RUN ${SPACK_ROOT}/bin/spack env create $SPACK_ENV_NAME

# Avoid having multiple versions of packages
RUN spack -e $SPACK_ENV_NAME config add concretizer:reuse:true
RUN spack -e $SPACK_ENV_NAME config add concretizer:unify:true

RUN spack -e $SPACK_ENV_NAME add netlib-lapack gsl silo+hdf5 hdf5+hl+fortran+cxx+mpi mpich openssl fftw papi protobuf hwloc adios2+hdf5 boost+  system+filesystem googletest gperftools openblas ssht yaml-cpp openpmd-api amrex@${AMREX_VER} ~cuda
RUN spack -e $SPACK_ENV_NAME develop -p $BASE/amrex~cuda amrex @${AMREX_VER} ~cuda

RUN spack -e $SPACK_ENV_NAME concretize -f
RUN spack -e $SPACK_ENV_NAME install --fail-fast

COPY mk-cfg.sh .
RUN bash ./mk-cfg.sh

USER etuser
WORKDIR /usr/etuser
COPY sim.tgz .
COPY build-cactus-tarball.sh .
RUN bash ./build-cactus-tarball.sh
USER root

# Set up slurm
RUN apt install slurmd slurm-client slurmctld -y
RUN apt install -y libpmix-bin libpmix-dev libpmix2
COPY slurm.conf /etc/slurm/
COPY cgroup.conf /etc/slurm/
COPY docker-entrypoint.sh /etc/slurm/
COPY relink.sh /

RUN apt install sudo -y && useradd -m admin -s /usr/bin/bash -d /home/admin && adduser admin sudo && echo "admin     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
COPY start-ldap.sh /usr/local/bin/
COPY etsetup.py /usr/local/lib/python${PYVER}/dist-packages/
RUN chmod 755 /usr/etuser/Cactus.tar.gz
RUN chmod 755 /usr/etuser
