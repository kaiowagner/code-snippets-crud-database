FROM ubuntu:16.04

RUN apt-get update && apt-get -y upgrade && apt-get -y install wget

RUN apt-get -y --no-install-recommends install \
    build-essential \
    cmake \
    coreutils \
    g++ \
    gcc \
    git-core \
    libsasl2-dev \
    libssl-dev 

# Installing the MongoDB C Driver (libmongoc) 
RUN git clone https://github.com/mongodb/mongo-c-driver.git
WORKDIR mongo-c-driver
RUN git checkout 1.10.1
RUN mkdir cmake-build
WORKDIR cmake-build
RUN cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF ..
RUN make
RUN make install

# Download the latest version of the mongocxx driver.
RUN git clone https://github.com/mongodb/mongo-cxx-driver.git \
    --branch releases/stable --depth 1
WORKDIR mongo-cxx-driver/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DBSONCXX_POLY_USE_MNMLSTC=1 \
    -DCMAKE_INSTALL_PREFIX=/usr/local ..
RUN make EP_mnmlstc_core
RUN make && make install

WORKDIR /app

CMD tail -f /dev/null
