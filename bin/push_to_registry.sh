#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

PROFIL="$1"
if [[ -z $PROFIL ]]; then 
    echo "Profil argument is unset"
    exit 1
fi

bin/make_oanda_env_file.sh || exit 1
docker-compose build --parallel || exit 1
docker-compose push
