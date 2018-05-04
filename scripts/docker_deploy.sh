#!/usr/bin/env sh

set -e

docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD";
version=$($(dirname "$0")/get_version.sh)
if [ "$TRAVIS_BRANCH" = "develop" ]
then
    docker tag wiseplat/solc:build wiseplat/solc:nightly;
    docker tag wiseplat/solc:build wiseplat/solc:nightly-"$version"-"$TRAVIS_COMMIT"
    docker push wiseplat/solc:nightly-"$version"-"$TRAVIS_COMMIT";
    docker push wiseplat/solc:nightly;
elif [ "$TRAVIS_TAG" = v"$version" ]
then
    docker tag wiseplat/solc:build wiseplat/solc:stable;
    docker tag wiseplat/solc:build wiseplat/solc:"$version";
    docker push wiseplat/solc:stable;
    docker push wiseplat/solc:"$version";
else
    echo "Not publishing docker image from branch $TRAVIS_BRANCH or tag $TRAVIS_TAG"
fi
