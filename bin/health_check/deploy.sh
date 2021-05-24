#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/../..

SERVICE_NAME="health-check"
IMAGE="eu.gcr.io/brushed-charts/health_check"
REGION="europe-west1"

cd services/health_check

# gcloud run deploy $SERVICE_NAME \
#     --image $IMAGE \
#     --platform managed \
#     --region $REGION \
#     --allow-unauthenticated