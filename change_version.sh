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

sed -e 's#^\(ENV VERSION \).*#\1 '$VERSION'#' -i Dockerfile

line='- ```'$tag'```'" (*[$tag/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/$tag/Dockerfile)*)"
echo $line >> README.md

git commit -m "changed to version $VERSION" Dockerfile tagged.versions README.md

if [ -n "$tag" ]; then
    git tag --force --annotate $tag -m "released version $tag" HEAD 
fi

git push 
git push --tags --force
