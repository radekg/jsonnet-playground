CURRENT_DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: tools
tools:
	mkdir -p /tmp/gomod-json && cd /tmp/gomod-json \
		&& git clone https://github.com/radekg/gomod-json.git . \
		&& $(MAKE) install \
		&& cd - && rm -rf /tmp/gomod-json \
	&& go install github.com/mikefarah/yq/v4@v4.34.1

.PHONY: docker-release
docker-release:
	docker buildx inspect --builder jsonnet-playground-builder; \
	[ $$? -eq 1 ] && docker buildx create --platform=linux/arm64,linux/amd64 --name jsonnet-playground-builder; \
	export JSONNET_VERSION=$(shell gomod-json --path=${CURRENT_DIR}/go.mod | yq '.Require[] | select(.Mod.Path == "github.com/google/go-jsonnet" and .Indirect == false) | .Mod.Version') \
	&& docker buildx build \
		--builder jsonnet-playground-builder \
		--platform linux/arm64,linux/amd64 \
		--push \
		--tag docker.io/radekg/jsonnet-playground:$${JSONNET_VERSION} \
		--tag docker.io/radekg/jsonnet-playground:latest . \
	&& docker buildx rm --builder jsonnet-playground-builder
