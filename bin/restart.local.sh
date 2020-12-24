#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

export PROFIL="dev"

docker-compose kill
bin/start.local.sh
