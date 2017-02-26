#!/bin/bash

set -e

function finish {
	local exitCode=$?

	echo "cleanup"
        docker image rm -f test-buddy >/dev/null

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

# build image
cd ..
docker build -t test-simple . > /dev/null
cd $OLDPWD

docker build -t test-buddy -f Dockerfile.test . >/dev/null

cid=$(docker run --rm -d \
	--cap-drop ALL \
	--cap-add SETUID \
	--cap-add SETGID \
	--cap-add SYS_ADMIN \
	test-buddy)
ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $cid)

set -x

# tests
curl -v --fail http://$ip:8080 >/dev/null 2>&1

set +x
