#!/usr/bin/env bash

docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASS"

set -ex

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --name multiarch --driver docker-container --use
docker buildx inspect --bootstrap

cd /simple-fop-server && docker buildx bake --push
