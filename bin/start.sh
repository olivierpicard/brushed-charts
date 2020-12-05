#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

export BCBPATH=$PWD # Brushed-Charts base path
export GOOGLE_APPLICATION_CREDENTIALS="/etc/brushed-charts/credentials/backend-institution_account-service.json"

echo -n "Choose a profile (dev|test|prod) [dev]: "
read -r profil
if [ -z $profil ]
then
    profil="dev"
fi 

echo "Use the profil : $profil"

