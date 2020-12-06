#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

export PROFIL="$1"

if [[ -z $PROFIL ]]; then 
    echo "argument profil(test|prod) is missing"
    exit 1
fi

if [[ $PROFIL != "test" && $PROFIL != "prod" ]]; then 
    echo "wrong argument try (test|prod)"
    exit 1
fi

bin/make_oanda_env_file.sh || exit 1
docker-compose build --parallel || exit 1
docker-compose push
