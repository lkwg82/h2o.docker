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


docker build -t test-buddy -f Dockerfile . >/dev/null

for test in $(find -type f -name test.sh); do
  echo "TEST: ${test}"
	pushd $(dirname $test)
	./$(basename $test)
	popd
done
