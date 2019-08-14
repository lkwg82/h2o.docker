#!/bin/bash

set -e

function finish {
	local exitCode=$?

	echo "cleanup"
        docker image rm -f test-buddy >/dev/null
        docker kill $(cat .cid)
        rm -f .cid

	echo "---------"	
	if [ "$exitCode" == "0" ]; then
		echo "Test: SUCCESS"
	else
		docker logs $cid 
		echo "Test: failed"
		exit $exitCode
	fi
}
trap finish EXIT

if [[ -z "${SKIP_BASEIMAGE_BUILD}" ]]; then
  # build image
  cd ../..
  echo -n "building base image ... "
  docker build -t test-h2o . > /dev/null
  echo ok
  cd $OLDPWD
fi

docker build -t test-buddy -f Dockerfile.test . >/dev/null

# cleanup, in case of previous error
rm -f .cid

docker run --rm \
  --cidfile .cid \
	--cap-drop ALL \
	--cap-add SETUID \
	--cap-add SETGID \
	--cap-add SYS_ADMIN \
	--detach \
	test-buddy

ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(cat .cid))

sleep 1

#set -x

# tests
curl -v --connect-timeout 1 --fail http://$ip:8080 >/dev/null 2>&1

#set +x
