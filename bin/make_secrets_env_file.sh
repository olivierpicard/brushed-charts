#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..


ENV_FILE_PATH="env/secrets.env"

API_TOKEN=$(bin/get_oanda_api_token.sh) || exit 1
ACCOUNT_ID=$(bin/get_oanda_account_id.sh) || exit 1
ADMIN_EMAIL_PASSWORD=$(bin/get_gmail_password.sh) || exit 1

if [ -z $API_TOKEN ]; then 
    echo "Can't retrieve API_TOKEN"
    exit 1
fi
if [ -z $ACCOUNT_ID ]; then 
    echo "Can't retrieve ACCOUNT_ID"
    exit 1
fi

if [ -z $ADMIN_EMAIL_PASSWORD ]; then 
    echo "Can't retrieve ADMIN_EMAIL_PASSWORD"
    exit 1
fi

rm -f $ENV_FILE_PATH || exit 2
touch $ENV_FILE_PATH || exit 2

echo "OANDA_API_TOKEN=$API_TOKEN" >> $ENV_FILE_PATH
echo "OANDA_ACCOUNT_ID=$ACCOUNT_ID" >> $ENV_FILE_PATH
echo "ADMIN_EMAIL_PASSWORD=$ADMIN_EMAIL_PASSWORD" >> $ENV_FILE_PATH
