#---------------------------

##################################################
##    intermediate stage to build CERN ROOT     ##
##################################################


FROM ubuntu:18.04

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get -y install \
  libgslcblas0 \
  python3-numpy \
  python3-scipy \
  python3-matplotlib \
  liblapack3 \
  libboost-all-dev \
  wget \
  git dpkg-dev cmake g++ gcc binutils libx11-dev libxpm-dev \
  libxft-dev libxext-dev

RUN wget https://root.cern/download/root_v6.18.02.source.tar.gz && tar -zxvf root_v6.18.02.source.tar.gz && rm root_v6.18.02.source.tar.gz

# arguments for cmake to use python3 for pyROOT
RUN mkdir /root-build && cd /root-build; cmake -DPYTHON_EXECUTABLE=/usr/bin/python3 ../root-6.18.02

RUN cd /root-build; make -j6

##################################################
##        build actual working container        ##
##################################################

# leave some 500 MB of root source files behind

FROM ubuntu:18.04

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get -y install \
  vim \
  nano \
  libgslcblas0 \
  python3-numpy \
  python3-scipy \
  python3-matplotlib \
  bc \
  liblapack3 \
  libboost-all-dev 


COPY --from=0 /root-build /root-build 

