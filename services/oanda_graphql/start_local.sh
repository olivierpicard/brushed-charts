#!/bin/zsh 

dirpath=$(dirname $(which $0))

cd "$dirpath"
docker build -t oanda_graphql .
cd "$dirpath/../../"

docker run \
    --restart always \
    --name oanda_graphql_local \
    --env-file env/services.env \
    --env-file env/services.dev.env \
    -p 3000:3000 \
    -d oanda_graphql
