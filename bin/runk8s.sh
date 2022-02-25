#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

BUILD_DIR="/tmp/buildk8s"

mkdir $BUILD_DIR 2> /dev/null
cp -r kubernetes/* $BUILD_DIR
grep -Rl '{{PROFIL}}' | xargs -i sed "s/{{PROFIL}}/$PROFIL/g"
microk8s kubectl apply -f $BUILD_DIR/