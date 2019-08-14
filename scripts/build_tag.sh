#!/bin/bash

set -e

tag=$1

latest=$(tail -n1 tagged.versions)
image="lkwg82/h2o-http2-server:$tag"
docker build --no-cache --pull --tag $image https://github.com/lkwg82/h2o.docker.git#$tag

pushd ..
./run_tests.sh
popd

docker push $image
if [[ "$latest" == "$tag" ]]; then
   docker tag lkwg82/h2o-http2-server:$latest lkwg82/h2o-http2-server:latest
   docker push lkwg82/h2o-http2-server:latest
   docker rmi lkwg82/h2o-http2-server:latest
fi
# cleanup local build cache
docker rmi $image
