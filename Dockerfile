# ------------------------------------------------------------------------------
# build stage
# Based on https://github.com/hiracchi/docker-alpine-buildbase
# Uses https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.0.tar.bz2
# ------------------------------------------------------------------------------
FROM alpine:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ARG OPENMPI_VER=3.1.3
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/octupole/alpine-openmpi" \
      org.label-schema.version=$VERSION

RUN set -x \
  && apk add --no-cache \
    tzdata \
  && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && apk add --no-cache --virtual .system \
    bash shadow sudo \
  && apk add --no-cache --virtual .editor \
    emacs vim \
  && apk add --no-cache --virtual .python \
    python3 \
  && apk add --no-cache --virtual .perl \
    perl \
  && apk add --no-cache --virtual .fftw \
    fftw \
  && apk add --no-cache --virtual .dev \
    make cmake musl-dev \
    gcc g++ gfortran \
    clang \
    file patch unzip git curl \
  && apk add --no-cache --virtual .dev-python \
    python3-dev \
    freetype-dev libpng-dev libjpeg-turbo-dev \
    libxml2-dev libxslt-dev \
  && apk add --no-cache --virtual .libs \
    freetype libpng libjpeg-turbo \
    libxml2 libxslt \
  && apk add --no-cache --virtual .linear-algebra-packages \
    openblas openblas-dev \
  && apk add --no-cache --virtual .dev-opencl \
    opencl-headers opencl-icd-loader

# OpenMPI
RUN set -x \
  && cd /tmp \
  && curl -O "https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-${OPENMPI_VER}.tar.bz2" \
  && tar xvfj "openmpi-${OPENMPI_VER}.tar.bz2" \
  && cd "/tmp/openmpi-${OPENMPI_VER}" \
  && mkdir build \
  && cd build \
  && ../configure --enable-mpi-cxx --disable-mpi-fortran \
  && make -j \
  && make install \
  && rm -rf "/tmp/openmpi-${OPENMPI_VER}"
