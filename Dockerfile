FROM alpine:3.7
MAINTAINER Lars K.W. Gohlke <lkwg82@gmx.de>

ENV URL     https://github.com/h2o/h2o.git
ENV VERSION  tags/v2.3.0-beta1

RUN apk update \
    && apk upgrade \
    # need for ocsp stapling \
    && apk add -U perl openssl \
    # just needed since v2
    && apk add -U libstdc++ \
    # save state before installed packages for building \
    && grep ^P /lib/apk/db/installed | sed -e 's#^P:##g' | sort > /before \
    && apk add -U build-base \
		  bison \
                  ca-certificates \
                  cmake \
                  git \
                  linux-headers \
		  ruby \
		          openssl-dev \
                  ruby-dev \
                  zlib-dev \
    && git clone $URL h2o \
    # build h2o \
    && cd h2o \
    && git checkout $VERSION \
    && cmake -DWITH_BUNDLED_SSL=on -DWITH_MRUBY=on \
    && make install \
    && cd .. \
    && rm -rf h2o \
    # remove packages installed just for building \
    && grep ^P /lib/apk/db/installed | sed -e 's#^P:##g' | sort > /after \
    && diff /before /after | grep -e "^+[^+]" | sed -e 's#+##g' | xargs -n1 apk del \
    && rm /before /after \
    && rm -rf /var/cache/apk/* \
    # just test it \
    && h2o -v
    
RUN mkdir /etc/h2o 
ADD h2o.conf /etc/h2o/
WORKDIR /etc/h2o
EXPOSE 8080 8443
CMD h2o --conf h2o.conf
