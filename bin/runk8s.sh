#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

BUILD_DIR="/tmp/k8sbuild"

rm -rf $BUILD_DIR
mkdir $BUILD_DIR 2> /dev/null
cp kubernetes/* $BUILD_DIR
grep -Rl '{{PROFIL}}' $BUILD_DIR | xargs sed -i 's/{{PROFIL}}/dev/'g

microk8s kubectl apply -f $BUILD_DIR