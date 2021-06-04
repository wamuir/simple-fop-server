.PHONY = buildx

buildx:
	docker run \
		-e CI_REGISTRY=${CI_REGISTRY} \
		-e CI_REGISTRY_USER=${CI_REGISTRY_USER} \
		-e CI_REGISTRY_PASS=${CI_REGISTRY_PASS} \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $(shell pwd):/simple-fop-server:ro \
		--entrypoint=/simple-fop-server/docker-bake.sh \
		--rm \
		jonoh/docker-buildx-qemu
