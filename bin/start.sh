#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

echo -n "Choose a profile (dev|test|prod) [dev]: "
read -r profil
if [ -z $profil ]; then
    profil="dev"
fi

echo "Use the profil : $profil"

bin/write_oanda_env_file.sh || exit 1

docker-compose \
    -f docker-compose.yml -f docker-compose.$profil.yml \
    up -d --build
