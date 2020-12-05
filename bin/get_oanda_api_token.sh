#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

# Get from env vars and GOOGLE_CREDENTIALS_PATH
set -o allexport
source ./env/services.env
set +o allexport


API_TOKEN=$(gcloud secrets \
    versions access latest \
    --secret="$SECRET_NAME_OANDA_API_TOKEN" \
    --quiet
)

echo "$API_TOKEN"