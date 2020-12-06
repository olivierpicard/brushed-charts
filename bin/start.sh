#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

echo -n "Choose a profile (dev|test|prod) [dev]: "
read -r profil
if [ -z $profil ]; then
    profil="dev"
fi
echo "Use profil: $profil"

# echo "Fetching secrets for oanda..."
# bin/make_oanda_env_file.sh || exit 1

if [[ $profil == "dev" ]]; then
    bin/start.local.sh $profil
else 
    echo "This deployment assume that you've already build and push image to registry"
    bin/start.stack.sh $profil
fi
