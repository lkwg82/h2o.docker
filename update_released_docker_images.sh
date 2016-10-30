#!/bin/bash

set -e

needUpdate=0
function checkforUpdates {
	local images="alpine ubuntu"
	for image in $images; do
		docker pull $image
	done
	
	local latest=$(docker inspect $images | jq '.[] | .RootFS' | sha1sum)
	if [ -e "images.latest" ]; then
		[[ $(cat images.latest) == $(echo $latest) ]] && echo "up-to-date" || needUpdate=1
	else				
		echo "need update"
	fi
	echo $latest > images.latest		
}

checkforUpdates

if [[ "$needUpdate" == "0" ]]; then 
	echo "no update needed"
	exit
fi


for tag in $(git tag); do
	echo "tag $tag"
	if [[ "$tag" =~ ^v2.* ]]; then
		docker build --no-cache --tag lkwg82/h2o-http2-server:$tag https://github.com/lkwg82/h2o.docker.git#$tag 
		docker push lkwg82/h2o-http2-server:$tag
	else 
		echo "ignore old versions"
	fi
done
