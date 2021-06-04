#!/usr/bin/env bash

set -ex

# build image and start container
IMAGE_ID=$(docker build -q ..)
CONTAINER_ID=$(docker run -d -p 8080:8080 ${IMAGE_ID})

# wait briefly to allow server to initialize
until $(curl --output /dev/null --silent --fail http://localhost:8080/health); do
    sleep 1
done

# expect a PDF result similar to https://xmlgraphics.apache.org/fop/dev/fo/embedding.fo.pdf
curl --fail https://xmlgraphics.apache.org/fop/dev/fo/embedding.fo \
    | curl --fail -XPOST --data-binary "@-" --output rendered.fo.pdf http://localhost:8080

# stop the running container
docker container stop ${CONTAINER_ID}
