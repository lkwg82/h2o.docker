FROM alpine as fetcher

RUN apk add --update git

ENV URL      https://github.com/h2o/h2o.git
ENV VERSION  v2.2.6
RUN git clone --depth 1 $URL -b $VERSION

FROM alpine as builder

RUN apk add --update libstdc++ \
    build-base \
    bison \
    ca-certificates \
    cmake \
    linux-headers \
    ruby \
    openssl-dev \
    ruby-dev \
    zlib-dev

COPY --from=fetcher /h2o /h2o
WORKDIR /h2o

# build h2o
RUN cmake -DWITH_BUNDLED_SSL=on -DWITH_MRUBY=on \
    && make -j 8 install

RUN h2o -v

FROM alpine
LABEL  maintainer "Lars K.W. Gohlke <lkwg82@gmx.de>"

# need for ocsp stapling
RUN    apk add -U --no-cache openssl perl libstdc++

RUN    addgroup h2o \
    && adduser -G h2o -D h2o
WORKDIR /home/h2o
USER h2o

COPY h2o.conf /home/h2o/

COPY --from=builder /usr/local/bin/h2o /usr/local/bin
COPY --from=builder /usr/local/share/h2o /usr/local/share/h2o
COPY --from=builder /usr/local/lib64/libh2o-evloop.a /usr/local/lib64/libh2o-evloop.a

EXPOSE 8080 8443

# some self tests
RUN    h2o -v \
    && h2o --conf h2o.conf --test

CMD h2o --conf h2o.conf
