#!/bin/zsh 

dirpath=$(dirname $(which $0))

cd "$dirpath"
docker build -t graphql_local .
cd "../../"

docker run \
    --restart always \
    --name graphql_local \
    --env-file env/services.env \
    --env-file env/services.test.env \
    -v /etc/brushed-charts/backend-institution_account-service.json:/etc/brushed-charts/backend-institution_account-service.json \
    -p 3330:3330 \
    -d graphql_local
