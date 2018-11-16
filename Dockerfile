FROM alpine:3.7 as builder
MAINTAINER Lars K.W. Gohlke <lkwg82@gmx.de>


RUN apk update && apk upgrade
# just needed since v2
RUN apk add libstdc++
RUN apk add \
      build-base \
      bison \
              ca-certificates \
              cmake \
              git \
              linux-headers \
      ruby \
              openssl-dev \
              ruby-dev \
              zlib-dev

ENV URL     https://github.com/h2o/h2o.git
ENV VERSION  tags/v2.3.0-beta1

RUN  git clone $URL h2o

# build h2o \
WORKDIR h2o
RUN git checkout $VERSION \
    && cmake -DWITH_BUNDLED_SSL=on -DWITH_MRUBY=on \
    && make install

RUN h2o -v

FROM alpine:3.7

COPY --from=builder /usr/local/bin/h2o /usr/local/bin
COPY --from=builder /usr/local/share/h2o /usr/local/share/h2o
COPY --from=builder /usr/local/lib64/libh2o-evloop.a /usr/local/lib64/libh2o-evloop.a

# need for ocsp stapling \
RUN    apk add -U --no-cache openssl perl \
# compress some
    && apk add upx \
    && find /usr -type f -name "*.so" -exec chmod u=+wx {} \; \
    && find /usr -type f -name "*.so" -exec upx -q9 {} \; \
    && apk del upx ucl \
    && rm -rf /var/lib/apk

RUN h2o -v

RUN mkdir /etc/h2o 
ADD h2o.conf /etc/h2o/
WORKDIR /etc/h2o
EXPOSE 8080 8443
CMD h2o --conf h2o.conf
