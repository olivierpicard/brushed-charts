#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

export PROFIL="dev"

docker-compose build --parallel || exit 1
docker-compose up -d
