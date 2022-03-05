#!/bin/bash 

#-----------------------------
# Author: Olivier PICARD 
# Description: 
#   Build each Dockerfile in services folder
#   and tag the image with GCP regristry name.
#   It will alse push to dev registry
# ----------------------------


REMOTE_REGISTRY='europe-docker.pkg.dev/brushed-charts/services'
DEV_REGISTRY='localhost:32000'

if [[ -z $PROFIL ]]; then
    echo '$PROFIL is not defined'
    exit 1
fi

dirpath=$(dirname $(which $0))
cd "$dirpath"/../..

cd services
list_of_dockerfile=$(find . -type f -name 'Dockerfile')

for file in $list_of_dockerfile; do
    service_path=$(dirname $file)
    service_name=$(basename $service_path)
    version=$(cat $service_path/version)
    docker buildx build $service_path \
        --load \
        --platform linux/arm64,linux/amd64 \
        --tag $REMOTE_REGISTRY/$service_name:version \
        --tag $DEV_REGISTRY/$service_name:version
    docker image push $DEV_REGISTRY/$service_name:version
done
