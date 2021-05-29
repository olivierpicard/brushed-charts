#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

# Get from env vars and OANDA_API_URL
set -o allexport
source ./env/services.env
set +o allexport

OANDA_ACCOUNT_URL="$OANDA_API_URL/v3/accounts"
API_TOKEN=$(bin/fetch_secret.sh $SECRET_NAME_OANDA_API_TOKEN) || exit 1

ACCOUNT_ID=$(curl \
    --silent \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_TOKEN" \
    $OANDA_ACCOUNT_URL
)

[[ $? != 0 ]] && exit 1
[[ -z $ACCOUNT_ID ]] && exit 1

echo $ACCOUNT_ID | \
    jq ".accounts | .[0] | .id" | \
    sed -e 's/^"//' -e 's/"$//' # Remove the first and last " 
