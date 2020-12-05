#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

# Get from env vars and OANDA_API_URL
set -o allexport
source ./env/services.env
set +o allexport

OANDA_ACCOUNT_URL="$OANDA_API_URL/v3/accounts"
FILE_NAME_ENV="env/oanda_secret.env"
API_TOKEN=$(bin/get_oanda_api_token.sh) || exit 1

ACCOUNT_ID=$(curl \
    --silent \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_TOKEN" \
    $OANDA_ACCOUNT_URL
)

[[ $? != 0]] && exit 1

echo $ACCOUNT_ID | \
    jq ".accounts | .[0] | .id" | \
    sed -e 's/^"//' -e 's/"$//' # Remove the first and last " 
