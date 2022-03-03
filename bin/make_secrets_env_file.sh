#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

ENV_FILE_PATH="env/secrets.env"

API_TOKEN=$(bin/fetch_secret.sh oanda-api-token) || exit 1
ACCOUNT_ID=$(bin/get_oanda_account_id.sh) || exit 1
OCI_USER_TOKEN=$(bin/fetch_secret.sh oci_user-token_brushed-charts-app) || exit 1

rm -f $ENV_FILE_PATH || exit 2

echo "OANDA_API_TOKEN=$API_TOKEN" >> $ENV_FILE_PATH
echo "OANDA_ACCOUNT_ID=$ACCOUNT_ID" >> $ENV_FILE_PATH
echo "OCI_USER_TOKEN_BRUSHED_CHARTS_APP=$OCI_USER_TOKEN" >> $ENV_FILE_PATH

chmod 400 $ENV_FILE_PATH