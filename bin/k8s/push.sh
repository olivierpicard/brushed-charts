#!/bin/bash 

#-----------------------------
# Author: Olivier PICARD 
# Description: 
#   Build each Dockerfile in services folder
#   and tag the image with GCP regristry name.
#   It will alse push to dev registry
# ----------------------------


REMOTE_REGISTRY='europe-docker.pkg.dev/brushed-charts/services'

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
    docker push image $REMOTE_REGISTRY/$service_name:$version
done
