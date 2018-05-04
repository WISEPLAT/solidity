#!/usr/bin/env sh

set -e

docker build -t wiseplat/solc:build -f scripts/Dockerfile .
tmp_container=$(docker create wiseplat/solc:build sh)
mkdir -p upload
docker cp ${tmp_container}:/usr/bin/solc upload/solc-static-linux
