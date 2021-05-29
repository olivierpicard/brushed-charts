#/bin/bash

docker run \
    --rm \
    -p 127.0.0.1:27017:27017 \
    -v /var/volumes/mongo-data/dev:/data/db \
    --name mongoDB \
    -d mongo:4.4
