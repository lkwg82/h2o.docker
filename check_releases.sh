#!/bin/bash

set -e
#set -x

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
releases=$(cat $apiResult | jq '.[] | .published_at + " " + .tag_name'| sed -e 's#"##g' | sort | cut -d\   -f2)

for r in $releases; do
    #~ echo -n "checking $r ... "
    if [ $(grep ^$r$ tagged.versions | wc -l) -eq 0 ]; then
        echo " tagging '$r'"
        echo $r >> tagged.versions
        changeVersion $r
        touch new_version
    #~ else
        #~ echo " ... already tagged"
    fi
done
