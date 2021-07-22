#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

echo -n "Choose a profile (dev|test|prod) [dev]: "
read -r profil
if [ -z $profil ]; then
    profil="dev"
fi
echo "Use profil: $profil"


echo "Fetching secrets..."
bin/make_secrets_env_file.sh || exit 1


if [[ $profil == "dev" ]]; then
    bin/start.local.sh $profil
else 
    echo ""
    echo "####################################################"
    echo "     This deployment assume that you've already  "
    echo "          build and push image to registry       "
    echo "####################################################"
    echo ""
    read -p "Have you push images to registry (y/n)? " yn
    [[ "$yn" != 'y' ]] && exit 1
    bin/start.stack.sh $profil
fi
