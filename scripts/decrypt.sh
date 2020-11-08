#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

creddir="/etc/brushed-charts"
localcred="./etc"
fname="backend-institution_account-service.json"

# Load the variables in the .env file if exist
if [ -f ".env" ]; then
    export $(cat .env | sed 's/#.*//g' | xargs)
fi 

# Decrypt into local credential dir using a passphrase, 
gpg --quiet --batch --yes --decrypt \
    --passphrase="$BACKEND_INSTITUTION_CREDENTIAL_PASS" \
    --output "${localcred}/${fname}" \
    "${localcred}/${fname}.gpg"

# Create directory with correct owner name. It will be use mostly
# on dev computer
if [ ! -d $creddir ]; then 
    sudo mkdir -p $creddir
fi

# Move the local credential to 'etc' dir 
sudo mv "${localcred}/${fname}" "${creddir}/${fname}"
