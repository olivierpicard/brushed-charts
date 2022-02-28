#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/../..

BUILD_DIR="/tmp/buildk8s"

if [[ -z $PROFIL ]]; then
    echo '$PROFIL is not defined'
    exit 1
fi

rm -rf $BUILD_DIR
mkdir $BUILD_DIR 2> /dev/null
cp -r kubernetes/* $BUILD_DIR/
grep -Rl '{{PROFIL}}' $BUILD_DIR | xargs sed -i "s/{{PROFIL}}/$PROFIL/g" 
microk8s kubectl delete -f $BUILD_DIR --grace-period=2
microk8s kubectl delete pvc --all