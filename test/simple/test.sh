#!/bin/bash

set -e

. ../lib.sh

docker run --rm \
  --cidfile .cid \
	--cap-drop ALL \
	--cap-add SETUID \
	--cap-add SETGID \
	--cap-add SYS_ADMIN \
	--detach \
	test-buddy > /dev/null

ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(cat .cid))

sleep 1

#set -x

# tests
curl -v --connect-timeout 1 --fail http://$ip:8080 >/dev/null 2>&1

#set +x
