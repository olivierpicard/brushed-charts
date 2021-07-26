#!/bin/zsh

dirpath=$(dirname $(which $0))
cd "$dirpath"/../services

PID_BASE_FILENAME="stack_labelling"

cd graphql
./start_local.sh &
cd ..

cd labelling
npm run dev < /dev/null &
echo $! > "/tmp/${PID_BASE_FILENAME}_labelling.pid"
./start_local.sh &
cd ..

cd ..
sleep 5
export PROFIL=dev
docker-compose up -d --build reverse_proxy





