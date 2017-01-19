#!/bin/bash

set -e

needUpdate=0
function checkforUpdates {
	local images=$@
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
if [ -e "new_version" ]; then
	rm new_version
else
	checkforUpdates alpine ubuntu debian
	if [[ "$needUpdate" == "0" ]]; then 
		echo "no update needed"
		exit
	fi
fi

latest=$(tail -n1 tagged.versions)
for tag in $(git tag); do
	echo "tag $tag"
	if [[ "$tag" =~ ^v2.* ]]; then
	        image="lkwg82/h2o-http2-server:$tag"
		docker build --no-cache --tag $image https://github.com/lkwg82/h2o.docker.git#$tag 
		docker push $image
		if [[ "$latest" == "$tag" ]]; then
			docker tag lkwg82/h2o-http2-server:$latest lkwg82/h2o-http2-server:latest
			docker push lkwg82/h2o-http2-server:latest
			docker rmi lkwg82/h2o-http2-server:latest
		fi
		# cleanup local build cache
		docker rmi $image
	else 
		echo "ignore old versions"
	fi
done
