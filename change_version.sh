#!/bin/bash

set -ex

branch=""
tag=""

if [ -z "$1" ]; then
    branch="master"
    VERSION="$branch"
else
    tag="$1"
    VERSION="tags/$tag"
fi

sed -e 's#^\(ENV VERSION \).*#\1'$VERSION'#' -i Dockerfile

git commit -m "changed to version $VERSION" Dockerfile

if [ -n "$branch" ]; then
    git tag --force --annotate $tag -m "released version $branch" HEAD 
fi    
if [ -n "$tag" ]; then
    git tag --force --annotate $tag -m "released version $tag" HEAD 
fi
#git push origin --tags