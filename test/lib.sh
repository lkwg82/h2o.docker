#!/bin/bash

set -e

function finish {
	local exitCode=$?

  echo ".. cleanup"
  if [[ -f ".cid" ]]; then
          docker image rm -f test-buddy >/dev/null
          docker kill $(cat .cid) > /dev/null
          rm -f .cid

    echo "---------"
    if [ "$exitCode" == "0" ]; then
      echo "Test: SUCCESS"
    else
      docker logs $cid
      echo "Test: failed"
      exit $exitCode
    fi
	fi
}
trap finish EXIT


if [[ -z ${SKIP_BASEIMAGE_BUILD} ]]; then
  # build image
  cd ../..
  echo -n "building base image ... "
  docker build -t test-h2o .
  echo ok
  cd $OLDPWD
fi

docker build -t test-buddy -f Dockerfile.test .

# cleanup, in case of previous error
rm -f .cid