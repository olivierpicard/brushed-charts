version=`cat version`
container=oanda-stream

.PHONY: unit-test linting build-and-push

linting:
	@docker build --tag oanda-stream:linting --target linting .
	@docker run --rm -it oanda-stream:linting

unit-test:
	@docker build --tag oanda-stream:unit-test --target unit-test .
	@docker run --rm -it oanda-stream:unit-test

modules-integration-test:
	@docker build --tag oanda-stream:modules-integration-test --target modules-integration-test .
	@docker run --rm -it oanda-stream:modules-integration-test

build:
	@docker build --tag oanda-stream:${version} --target service .
