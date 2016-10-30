#!/bin/bash

set -e

for tag in $(git tag); do
	echo "tag $tag"
	if [[ "$tag" =~ ^v2.* ]]; then
		docker build --no-cache --tag lkwg82/h2o-http2-server:$tag https://github.com/lkwg82/h2o.docker.git#$tag 
		docker push lkwg82/h2o-http2-server:$tag
	else 
		echo "ignore old versions"
	fi
done
