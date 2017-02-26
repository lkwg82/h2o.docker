#!/bin/bash

set -e

needUpdate=0
function checkforUpdates {
	local images=$@
	for image in $images; do
		docker pull $image
	done
	
	local latest=$(docker inspect $images | jq '.[] | .RootFS' | sha1sum)
	if [ -e ".images.latest" ]; then
		[[ $(cat .images.latest) == $(echo $latest) ]] && echo "up-to-date" || needUpdate=1
	else				
		echo "need update"
		needUpdate=1
	fi
	echo $latest > .images.latest		
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

for tag in $(git tag); do
	echo "tag $tag"
	if [[ "$tag" =~ ^v2.* ]]; then
		./build_tag.sh $tag
	else 
		echo "ignore old versions"
	fi
done
