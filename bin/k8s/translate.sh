#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/../..

INPUT_FILE="$1"
BUILD_DIR="/tmp/buildk8s"
REMOTE_REGISTRY='europe-docker.pkg.dev\/brushed-charts\/services\/'
context_registry=''
pv_hostname='dev-1'

if [[ -z $PROFIL ]]; then
    echo '$PROFIL is not defined'
    exit 1
elif [[ $PROFIL != 'dev' ]]; then
    context_registry=$REMOTE_REGISTRY
    pv_hostname='prod-de1'
fi

file_content=$(cat $INPUT_FILE)
file_content=$(sed "s/{{PROFIL}}/$PROFIL/g" <<< "$file_content")
file_content=$(sed "s/{{REGISTRY_URL}}/$context_registry/g" <<< "$file_content")
file_content=$(sed "s/{{PV-HOSTNAME}}/$pv_hostname/g" <<< "$file_content")

echo "$file_content"