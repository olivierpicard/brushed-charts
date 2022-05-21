#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/../..

cd helm-charts

PROFIL="$1"

if [[ -z $PROFIL ]];
    echo "A profil should be set as argument <dev | test | prod>"
    exit 1
fi

# Assume that configMap and secrets are already in cluster

helm install --values "$PROFIL-values.yaml" brushed-charts .
