#!/bin/bash

set -e

. ../lib.sh

# issue: https://github.com/lkwg82/h2o.docker/issues/8
# perl in container causes bus error

# tests
docker run -t test-buddy /bin/sh -c 'perl -v && date' > /dev/null
