version=`cat version`
save-dir=/tmp/docker_save_path
image=europe-docker.pkg.dev/brushed-charts/services/oanda-stream
image-only=oanda-stream


.PHONY: linting unit-test build push-amd64 push-arm64 arch-fusion push-manifest

linting:
	@docker build --tag ${image}:${version}-linting --target linting .
	@docker run --rm -it ${image}:${version}-linting

unit-test:
	@docker build --tag ${image}:${version}-unit-test --target unit-test .
	@docker run --rm -it ${image}:${version}-unit-test

build:
	@docker build --tag ${image}:${version} --target service .

push-arm64:
	@docker tag ${image}:${version} ${image}:${version}-arm64
	@docker push ${image}:${version}-arm64 

push-amd64:
	@docker tag ${image}:${version} ${image}:${version}-amd64
	@docker push ${image}:${version}-amd64 

arch-fusion:
	@docker manifest create ${image}:${version} \
		--amend ${image}:${version}-amd64 \
		--amend ${image}:${version}-arm64

push-manifest:
	@docker manifest push ${image}:${version}
