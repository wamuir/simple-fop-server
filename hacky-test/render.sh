#!/usr/bin/env bash

set -ex

IMAGE_ID=$(docker build -q ..)
CONTAINER_ID=$(docker run -d -p 8080:8080 ${IMAGE_ID})

sleep 2
# embedding.fo has embedded SVG
# expect an output like https://xmlgraphics.apache.org/fop/dev/fo/embedding.fo.pdf
curl --fail -XPOST --data-binary "@embedding.fo" http://localhost:8080 -o rendered.fo.pdf

docker container stop ${CONTAINER_ID}
