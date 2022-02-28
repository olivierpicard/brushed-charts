#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/../..

BUILD_DIR="/tmp/buildk8s"
REMOTE_REGISTRY='eu.gcr.io/brushed-charts'
DEV_REGISTRY='localhost:32000'
context_registry=$DEV_REGISTRY

if [[ -z $PROFIL ]]; then
    echo '$PROFIL is not defined'
    exit 1
elif [[ $PROFIL != 'dev' ]]; then
    context_registry=$REMOTE_REGISTRY
fi

rm -rf $BUILD_DIR
mkdir $BUILD_DIR 2> /dev/null
cp -r kubernetes/* $BUILD_DIR/

grep -Rl '{{PROFIL}}' $BUILD_DIR | xargs sed -i "s/{{PROFIL}}/$PROFIL/g" 
grep -Rl '{{REGISTRY_URL}}' $BUILD_DIR | xargs sed -i "s/{{REGISTRY_URL}}/$context_registry/g" 


microk8s kubectl create configmap general-services \
    --from-env-file=env/services.env \
    --dry-run=client \
    -o yaml \
    | microk8s kubectl apply -f -

microk8s kubectl create configmap dev-services \
    --from-env-file=env/services.dev.env \
    --dry-run=client \
    -o yaml \
    | microk8s kubectl apply -f -

microk8s kubectl create configmap test-services \
    --from-env-file=env/services.test.env \
    --dry-run=client \
    -o yaml \
    | microk8s kubectl apply -f -

microk8s kubectl create configmap prod-services \
    --from-env-file=env/services.prod.env \
    --dry-run=client \
    -o yaml \
    | microk8s kubectl apply -f -

microk8s kubectl create configmap watchlist \
    --from-file=oanda=/etc/brushed-charts/oanda_watchlist.txt \
    --dry-run=client \
    -o yaml \
    | microk8s kubectl apply -f -

microk8s kubectl create secret generic env-secret \
    --from-env-file=env/secrets.env \
    --dry-run=client \
    -o yaml \
    | microk8s kubectl apply -f -

microk8s kubectl create secret generic gcp-backend-institution-service-account \
    --from-file=/etc/brushed-charts/backend-institution_account-service.json \
    --dry-run=client \
    -o yaml \
    | microk8s kubectl apply -f -

microk8s kubectl apply -f $BUILD_DIR/
