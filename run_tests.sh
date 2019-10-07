#!/bin/bash

set -o pipefail
set -e

function finish {
        local exitCode=$?

	echo
        echo "----------------------"
        if [ "$exitCode" == "0" ]; then
                echo "Tests: SUCCESS"
        else
                echo "Tests: failed"
                exit $exitCode
        fi
}
trap finish EXIT

if [[ -z "${BASEIMAGE_TAG}" ]]; then
  docker build -t test-h2o -f Dockerfile . >/dev/null
else
  docker tag ${BASEIMAGE_TAG} test-h2o
fi

for test in $(find -type f -name test.sh); do
  echo "TEST: ${test}"
	pushd $(dirname $test) > /dev/null
	SKIP_BASEIMAGE_BUILD=0 ./$(basename $test)
	popd > /dev/null
done
