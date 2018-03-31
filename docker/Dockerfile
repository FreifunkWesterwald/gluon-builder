FROM debian:jessie

LABEL Description="Gluon builder with Debain Jessie"
MAINTAINER Christian Paffhausen <mail@thepaffy.de>

# set environment
ENV LANG=en_US.UTF-8

RUN echo 'Debug::pkgProblemResolver "true";' > /etc/apt/apt.conf.d/Debug
RUN apt update && apt-get install -y \
  git \
  subversion \
  python \
  build-essential \
  gawk \
  unzip \
  libncurses5-dev \
  zlib1g-dev \
  libssl-dev \
  wget \
  locales

RUN locale-gen en_US.UTF-8

RUN groupadd -g 1000 gluon && \
  useradd -m -u 1000 -g 1000 -d /home/gluon gluon && \
  echo 'gluon:gluon' | chpasswd && \
  echo "gluon ALL=NOPASSWD:ALL" >> /etc/sudoers

RUN addgroup builders && \
  usermod -G builders gluon

RUN apt-get autoremove -y

RUN echo "Configuration finished, finalizing Docker image..."

# automatically login as user "gluon"
USER gluon

# set cache to 24h
RUN git config --global credential.helper 'cache --timeout=86400'
