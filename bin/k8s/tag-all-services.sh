#!/bin/bash 

#-----------------------------
# Author: Olivier PICARD 
# Description: 
#   Build each Dockerfile in services folder
#   and tag the image with GCP regristry name.
#   It will alse push to dev registry
# ----------------------------


REMOTE_REGISTRY='eu.gcr.io/brushed-charts'
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
    (docker build $service_path \
        -t $REMOTE_REGISTRY/$service_name:prod-latest \
        -t $REMOTE_REGISTRY/$service_name:test-latest \
        -t $DEV_REGISTRY/$service_name:dev-latest \
    && docker image push $DEV_REGISTRY/$service_name:dev-latest)
done
