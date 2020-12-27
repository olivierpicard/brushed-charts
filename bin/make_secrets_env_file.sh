#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

ENV_FILE_PATH="env/secrets.env"

API_TOKEN=$(bin/fetch_secret.sh oanda-api-token) || exit 1
ACCOUNT_ID=$(bin/get_oanda_account_id.sh) || exit 1
ADMIN_EMAIL_PASSWORD=$(bin/fetch_secret.sh gmail_olivier-picard-m_password) || exit 1

rm -f $ENV_FILE_PATH || exit 2

echo "OANDA_API_TOKEN=$API_TOKEN" >> $ENV_FILE_PATH
echo "OANDA_ACCOUNT_ID=$ACCOUNT_ID" >> $ENV_FILE_PATH
echo "ADMIN_EMAIL_PASSWORD=$ADMIN_EMAIL_PASSWORD" >> $ENV_FILE_PATH

chmod 400 $ENV_FILE_PATH