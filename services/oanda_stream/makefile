version=`cat version`
save-dir=/tmp/docker_save_path
image=eu.gcr.io/brushed-charts/oanda-stream
image-only=oanda-stream


.PHONY: unit-test linting build save-amd64 save-arm64 arch-fusion push

linting:
	@docker build --tag ${image}:${version}-linting --target linting .
	@docker run --rm -it ${image}:${version}-linting

unit-test:
	@docker build --tag ${image}:${version}-unit-test --target unit-test .
	@docker run --rm -it ${image}:${version}-unit-test

build:
	@docker build --tag ${image}:${version} --target service .

save-amd64:
	@docker tag ${image}:${version} ${image}:${version}-amd64
	@docker save ${image}:${version}-amd64 > ${save-dir}/${image-only}.${version}-amd64.tar

save-arm64:
	@docker tag ${image}:${version} ${image}:${version}-arm64
	@docker save ${image}:${version}-arm64 > ${save-dir}/${image-only}.${version}-arm64.tar

arch-fusion:
	@docker load -i ${save-dir}/${image-only}.${version}-arm64.tar
	@docker load -i ${save-dir}/${image-only}.${version}-amd64.tar
	@docker manifest create ${image}:${version} \
		--amend ${image}:${version}-amd64 \
		--amend ${image}:${version}-arm64

push:
	@docker manifest push ${image}:${version}
