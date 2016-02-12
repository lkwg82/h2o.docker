#!/bin/bash

set -e

apiResult=api.releases
#curl https://api.github.com/repos/h2o/h2o/releases > $apiResult
releases=$(cat $apiResult | jq '.[].tag_name'| sed -e 's#"##g' | sort)

for r in $releases; do
    echo -n "checking $r ... "
    if [ $(grep ^$r$ tagged.versions | wc -l) -eq 0 ]; then
        echo " tagging"
        ./change_version.sh $r
        echo $r >> tagged.versions
    else
        echo " ... already tagged"
    fi
done

#./change_version.sh master

