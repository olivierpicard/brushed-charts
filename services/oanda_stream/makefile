version=`cat version`
container=oanda_stream

.PHONY: unit-test linting build-and-push

linting:
	@docker build --tag oanda_stream:linting --target linting .
	@docker run --rm -it oanda_stream:linting

unit-test:
	@docker build --tag oanda_stream:unit-test --target unit-test .
	@docker run --rm -it oanda_stream:unit-test

modules-integration-test:
	@docker build --tag oanda_stream:modules-integration-test --target modules-integration-test .
	@docker run --rm -it oanda_stream:modules-integration-test

build-and-push:
	@docker build --tag oanda_stream:${version} --target production .