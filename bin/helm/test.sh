#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/../..

cd helm-charts

PROFIL="$1"
RELEASE_NAME="brushed-charts"

if [[ -z $PROFIL ]]; then
    echo "A profil should be set as argument <dev | test | prod>"
    exit 1
fi

helm test $RELEASE_NAME