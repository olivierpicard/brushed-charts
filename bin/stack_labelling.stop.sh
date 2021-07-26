#!/bin/zsh

dirpath=$(dirname $(which $0))
cd "$dirpath"/../services

PID_BASE_FILENAME="stack_labelling"

cd graphql
./stop_local.sh
cd ..

cd labelling
cat "/tmp/${PID_BASE_FILENAME}_labelling.pid" | xargs kill -KILL
./stop_local.sh
cd ..

cd ..
export PROFIL=dev
docker-compose kill reverse_proxy





