#!/bin/zsh 

dirpath=$(dirname $(which $0))
absolute_path=`cd $dirpath/../ && pwd`

cd "$dirpath/../"
docker build -t graphql_local -f ./Dockerfile-dev .
cd "../../"

docker run \
    --restart no \
    --name graphql_local \
    --hostname graphql \
    --network brushed-charts_default \
    --env-file env/services.env \
    --env-file env/services.dev.env \
    -v $absolute_path/src:/usr/src/app/src/ \
    -v /etc/brushed-charts/backend-institution_account-service.json:/etc/brushed-charts/backend-institution_account-service.json \
    -p 4000:80 \
    -d graphql_local
