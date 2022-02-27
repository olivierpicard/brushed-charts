#!/bin/bash

microk8s kubectl create secret docker-registry gcr-json-key \
    --docker-server=eu.gcr.io \
    --docker-username=_json_key \
    --docker-password="$(cat /etc/brushed-charts/gcp-accservice_docker-configurator.json)" \
    --docker-email=docker-configurator@brushed-charts.iam.gserviceaccount.com