#!/bin/bash

microk8s kubectl create secret docker-registry --dry-run=client -o yaml gcr-json-key \
    --docker-server=europe-docker.pkg.dev \
    --docker-username=_json_key \
    --docker-password="$(cat /etc/brushed-charts/gcp-accservice_artifact-reader.json)" \
    --docker-email=artifact-reader@brushed-charts.iam.gserviceaccount.com \
    | microk8s kubectl apply -f -