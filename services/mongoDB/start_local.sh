#/bin/bash

docker run \
    --restart always \
    -p 27017:27017 \
    --name mongoDB \
    -d mongo:4.4
