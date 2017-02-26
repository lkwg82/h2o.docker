#!/bin/bash

set -e

git pull
pushd scripts
./check_releases.sh
./update_released_docker_images.sh
popd
