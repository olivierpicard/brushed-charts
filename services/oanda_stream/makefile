version=`cat version`
container=oanda-stream

.PHONY: unit-test linting build

linting:
	@docker build --tag oanda-stream:${version}-linting --target linting .
	@docker run --rm -it oanda-stream:linting

unit-test:
	@docker build --tag oanda-stream:${version}-unit-test --target unit-test .
	@docker run --rm -it oanda-stream:unit-test

build:
	@docker build --tag oanda-stream:${version} --target service .

push:
	@docker 
