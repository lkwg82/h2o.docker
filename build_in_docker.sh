#!/bin/bash

set -e
set -x

if [ -z "$1" ]; then
    version="master"
else
    version="$1"
fi

tag=build-h2o
docker build --file Dockerfile.build -t $tag .

docker run \
        -v /var/run/docker.sock:/var/run/docker.sock \
        --cidfile=.cid \
        -ti $tag $version
     
CID=$(cat .cid)     
docker cp $CID:/h2o.bin.tar .

docker rm $CID
rm .cid

repository=lkwg82/h2o-http2-server:$(echo -n $version | sed -e 's#tags/v##')
docker build -t $repository -f Dockerfile.version .
rm h2o.bin.tar

docker run -ti $repository h2o -tv
docker push $repository