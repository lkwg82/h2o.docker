#!/bin/bash

set -e

git pull
./check_releases.sh
./update_released_docker_images.sh
