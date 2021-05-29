#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/../..

IMAGE="eu.gcr.io/brushed-charts/health_check"

cd services/health_check

docker build -t $IMAGE . || exit 1
docker push $IMAGE || exit 1
