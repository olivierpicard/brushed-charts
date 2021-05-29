#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

PROFIL="$1"

stack_to_remove="brushed-charts-$PROFIL"

echo "This command will remove the stack: $stack_to_remove"
echo -n "Are you sure you want to STOP the profil $PROFIL (y/n): "
read -r confimatation
if [[ $confimatation != 'y' ]]; then
    echo "no services was stopped"
    exit 1
fi

docker stack rm $stack_to_remove