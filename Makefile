.PHONY: build shell

docker-run := docker run \
	--rm -ti \
	-v $(shell pwd):/code \
	keyvalue-kubernetes-configmap-ruby:latest

build:
	docker build \
		-t keyvalue-kubernetes-configmap-ruby:latest \
		.

shell: build
	$(docker-run) bash
