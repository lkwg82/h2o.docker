FROM alpine
MAINTAINER Lars K.W. Gohlke <lkwg82@gmx.de>

ENV VERSION tags/v1.6.3

RUN apk update \
    && apk upgrade \
    # need for ocsp stapling \
    && apk add -U perl openssl \
    && apk add -U build-base \
                  cmake \
                  git \
                  linux-headers \
                  zlib-dev \
                  ca-certificates \
    && git clone https://github.com/h2o/h2o.git h2o \
    && cd h2o \
    && git checkout $VERSION \
    && cmake -DWITH_BUNDLED_SSL=on . \
    && make install \
    && cd .. \
    && rm -rf h2o \
    && apk del build-base \
               cmake \
               git \
               linux-headers \
               zlib-dev \
               ca-certificates \
    && rm -rf /var/cache/apk/*
    
RUN mkdir /etc/h2o
ADD h2o.conf /etc/h2o/
WORKDIR /etc/h2o
EXPOSE 80 443
CMD h2o