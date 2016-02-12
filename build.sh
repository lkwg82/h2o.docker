#!/bin/ash

set -e

if [ -z "$1" ]; then
    version="master"
else
    version="$1"
fi

git pull 
git checkout $version 
cmake -DWITH_BUNDLED_SSL=on . 
make clean
make install 
make clean 
tar -cvf /h2o.bin.tar /usr/local/bin/h2o /usr/local/share/h2o/