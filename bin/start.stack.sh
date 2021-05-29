#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

export PROFIL="$1"
STACK_NAME="brushed-charts-$1"

docker stack deploy \
    --with-registry-auth \
    --prune \
    -c docker-compose.yml \
    $STACK_NAME