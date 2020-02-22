.PHONY: build shell

KUBECONFIG ?= ~/.kube/config

docker-run := docker run \
	--rm -ti \
	--env-file config/environment \
	-v $(shell pwd):/code \
	-v $(shell pwd)/bundle:/usr/local/bundle/ \
	-v $(KUBECONFIG):/code/.kube/config \
	keyvalue-kubernetes-configmap-ruby:latest

build:
	docker build \
		-t keyvalue-kubernetes-configmap-ruby:latest \
		.

shell: build
	$(docker-run) bash
