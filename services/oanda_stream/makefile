version=`cat version`
save-dir=/tmp/docker_save_path
image=europe-docker.pkg.dev/brushed-charts/services/oanda-stream
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
	@mkdir -p ${save-dir}
	@docker tag ${image}:${version} ${image}:${version}-amd64
	@docker save ${image}:${version}-amd64 > ${save-dir}/${image-only}.${version}-amd64.tar

save-arm64:
	@mkdir -p ${save-dir}
	@docker tag ${image}:${version} ${image}:${version}-arm64
	@docker save ${image}:${version}-arm64 > ${save-dir}/${image-only}.${version}-arm64.tar

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
