#!/bin/bash 

#-----------------------------
# Author: Olivier PICARD 
# Description: 
#   Build each Dockerfile in services folder
#   and tag the image with GCP regristry name.
#   It will alse push to dev registry
# ----------------------------

#--------- FUNCTIONS ----------

function check_environment_var {
    if [[ -z $RELEASE_PROFILE ]]; then
        echo -e 'arguments RELEASE_PROFILE is not defined.' >&2
        echo './publish <dev | test | prod>' >&2
        exit 1
    elif [[ $RELEASE_PROFILE != 'dev' ]] \
            && [[ $RELEASE_PROFILE != 'test' ]] \
            && [[ $RELEASE_PROFILE != 'prod' ]]; then
        echo "RELEASE_PROFILE is not valide." >&2
        echo "Use <dev | test | prod>" >&2
        exit 1
    fi
}

function build_and_push {
    if [[ $RELEASE_PROFILE == 'dev' ]]; then
        dev_push
    else 
        multi_architecture_push
    fi
}

function dev_push {
    docker build $service_path --tag $service_name:$version
}

function multi_architecture_push {
    docker buildx build $service_path \
        --push \
        --platform linux/arm64,linux/amd64 \
        --tag $REMOTE_REGISTRY/$service_name:$version
}

function discover {
    local file="$1"
    service_path=$(dirname $file)
    service_name=$(basename $service_path)
    version=$(cat $service_path/version)
}

#--------- MAIN ----------

REMOTE_REGISTRY='europe-docker.pkg.dev/brushed-charts/services'
RELEASE_PROFILE="$1"
SERVICE_TO_BUILD="$2"

dirpath=$(dirname $(which $0))
cd "$dirpath"/../..
cd services

check_environment_var

if [[ -z SERVICE_TO_BUILD ]]; then
    list_of_dockerfile=$(find . -type f -name 'Dockerfile')
    for file in $list_of_dockerfile; do
        discover $file
        build_and_push
    done
else
    discover $SERVICE_TO_BUILD/Dockerfile
    build_and_push
fi
