#!/bin/bash

set -e

function changeVersion {
    if [ -z "$1" ]; then
        echo "missing tag"
        exit 1
    fi

    tag="$1"
    VERSION="tags/$tag"

    sed -e 's#^\(ENV VERSION \).*#\1 '$VERSION'#' -i Dockerfile

    line='- ```'$tag'```'" (*[$tag/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/$tag/Dockerfile)*)"
    echo $line >> README.md

    git commit -m "changed to version $VERSION" Dockerfile tagged.versions README.md
    git tag --force --annotate $tag -m "released version $tag" HEAD 

    git push 
    git push --tags --force
}

apiResult=api.releases
curl -s https://api.github.com/repos/h2o/h2o/releases > $apiResult
releases=$(cat $apiResult | jq '.[].tag_name'| sed -e 's#"##g' | sort)

for r in $releases; do
    #~ echo -n "checking $r ... "
    if [ $(grep ^$r$ tagged.versions | wc -l) -eq 0 ]; then
        echo " tagging '$r'"
        changeVersion $r
        echo $r >> tagged.versions
    #~ else
        #~ echo " ... already tagged"
    fi
done
