.PHONY = buildx

buildx:
	docker run -it --rm \
		-e CI_REGISTRY=${CI_REGISTRY} \
		-e CI_REGISTRY_USER=${CI_REGISTRY_USER} \
		-e CI_REGISTRY_PASS=${CI_REGISTRY_PASS} \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /home/trent/github.com/wamuir/simple-fop-server:/simple-fop-server:ro \
		jonoh/docker-buildx-qemu /simple-fop-server/docker-bake.sh
