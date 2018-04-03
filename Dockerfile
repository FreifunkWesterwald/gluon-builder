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

RUN apt-get autoremove -y
