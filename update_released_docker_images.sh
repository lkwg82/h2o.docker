#!/bin/bash

set -e

needUpdate=1
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
	        image="lkwg82/h2o-http2-server:$tag"
		docker build --no-cache --tag $image https://github.com/lkwg82/h2o.docker.git#$tag 
		docker push $image
		# cleanup local build cache
		docker rmi $image
	else 
		echo "ignore old versions"
	fi
done

latest=$(tail -n1 tagged.versions)
docker tag lkwg82/h2o-http2-server:$latest lkwg82/h2o-http2-server:latest
docker push lkwg82/h2o-http2-server:latest
