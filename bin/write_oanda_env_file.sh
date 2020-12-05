#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..


ENV_FILE_PATH="env/oanda_secret.env"

API_TOKEN=$(bin/get_oanda_api_token.sh) || exit 1 
ACCOUNT_ID=$(bin/get_oanda_account_id.sh) || exit 1

rm -f $ENV_FILE_PATH || exit 2
touch $ENV_FILE_PATH || exit 2

echo "OANDA_API_TOKEN=\"$API_TOKEN\"" >> $ENV_FILE_PATH
echo "OANDA_ACCOUNT_ID=\"$ACCOUNT_ID\"" >> $ENV_FILE_PATH
