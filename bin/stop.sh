#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

echo -n "Choose a profile to stop (dev|test|prod) [dev]: "
read -r profil
if [ -z $profil ]; then
    profil="dev"
fi


if [[ $profil == 'dev' ]]; then
    bin/stop.local.sh $profil
else
    bin/stop.stack.sh $profil
fi