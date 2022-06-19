repository=europe-docker.pkg.dev/brushed-charts/charts

.PHONY: package push pull

package:
	@helm package .

push:
	@helm push brushed-charts*.tgz oci://${repository}

