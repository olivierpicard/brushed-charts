#!/bin/bash

export GOOGLE_APPLICATION_CREDENTIALS="/etc/brushed-charts/backend-institution_account-service.json"

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

echo -n "Choose a profile (dev|test|prod) [dev]: "
read -r profil
if [ -z $profil ]; then
    profil="dev"
fi

echo "Use the profil : $profil"

bin/write_oanda_env_file.sh

docker-compose \
    -f docker-compose.yml -f docker-compose.$profil.yml \
    up -d --build
