#!/bin/zsh

dirpath=$(dirname $(which $0))
cd $dirpath/../services

PID_BASE_FILENAME="stack_labelling"

cd graphql
bin/start_local.sh &
cd ..

cd ..
sleep 5
export PROFIL=dev
docker-compose up -d --build reverse_proxy





