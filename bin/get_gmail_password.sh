#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

# Get from env vars and GOOGLE_CREDENTIALS_PATH
set -o allexport
source ./env/services.env
set +o allexport


email_password=$(gcloud secrets \
    versions access latest \
    --secret="gmail_olivier-picard-m_password" \
    --quiet
)

[[ $? != 0 ]] && exit 1

echo "$email_password"