#/bin/bash

docker run \
    --restart=always \
    -p 127.0.0.1:27017:27017 \
    -v /var/volumes/mongo-data/dev:/data/db \
    --name mongo_local \
    -d mongo:4.4
