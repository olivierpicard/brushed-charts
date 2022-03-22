#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/../..

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

rm -rf $BUILD_DIR
mkdir $BUILD_DIR 2> /dev/null
cp -r kubernetes/* $BUILD_DIR/

grep -Rl '{{PROFIL}}' $BUILD_DIR | xargs sed -i '' "s/{{PROFIL}}/$PROFIL/g" 
grep -Rl '{{REGISTRY_URL}}' $BUILD_DIR | xargs sed -i '' "s/{{REGISTRY_URL}}/$context_registry/g" 
grep -Rl '{{PV-HOSTNAME}}' $BUILD_DIR | xargs sed -i '' "s/{{PV-HOSTNAME}}/$pv_hostname/g" 

shopt -s expand_aliases
if [[ -f ~/.bash_aliases ]]; then
    source ~/.bash_aliases
fi


kubectl create configmap general-services \
    --from-env-file=env/services.env \
    --dry-run=client \
    -o yaml \
    | kubectl apply -f -

kubectl create configmap dev-services \
    --from-env-file=env/services.dev.env \
    --dry-run=client \
    -o yaml \
    | kubectl apply -f -

kubectl create configmap test-services \
    --from-env-file=env/services.test.env \
    --dry-run=client \
    -o yaml \
    | kubectl apply -f -

kubectl create configmap prod-services \
    --from-env-file=env/services.prod.env \
    --dry-run=client \
    -o yaml \
    | kubectl apply -f -

kubectl create configmap watchlist \
    --from-file=oanda-txt=/etc/brushed-charts/oanda_watchlist.txt \
    --from-file=oanda=/etc/brushed-charts/oanda_watchlist.json \
    --from-file=kraken=/etc/brushed-charts/kraken_watchlist.txt \
    --dry-run=client \
    -o yaml \
    | kubectl apply -f -

kubectl create secret generic env-secret \
    --from-env-file=env/secrets.env \
    --dry-run=client \
    -o yaml \
    | kubectl apply -f -

kubectl create secret generic gcp-backend-institution-service-account \
    --from-file=/etc/brushed-charts/backend-institution_account-service.json \
    --dry-run=client \
    -o yaml \
    | kubectl apply -f -

kubectl apply -f $BUILD_DIR/
