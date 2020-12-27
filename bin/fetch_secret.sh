#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

# Get from env vars and GOOGLE_CREDENTIALS_PATH
set -o allexport
source ./env/services.env
set +o allexport

SECRET_NAME="$1"

secret=$(gcloud secrets \
    versions access latest \
    --secret="$SECRET_NAME" \
    --quiet
)

[[ $? != 0 ]] && exit 1
[[ -z $secret ]] && exit 1

echo "$secret"