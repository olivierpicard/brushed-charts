#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

etcdir="/etc/brushed-charts"
google_cred_filename="backend-institution_account-service.json"
oci_key_filename="oci_key_brushed-charts-app.pem"
oci_config_filename="oci-brushed-charts-app-config"

export $(cat .vscode/.env | sed 's/#.*//g' | xargs)
mkdir -p $etcdir

# Decrypt gcloud key into local credential dir using a passphrase, 
echo -e "$PASSWORD_FOR_GPG_FILES" | gpg \
--quiet --batch --yes \
    --passphrase-fd 0 --decrypt \
    --output "$etcdir/$google_cred_filename" \
    ./etc/$google_cred_filename.gpg && echo "✅ gcloud key decrypted"

# Decrypt Oracle cloud key into local credential dir using a passphrase, 
echo -e "$PASSWORD_FOR_GPG_FILES" | gpg \
    --quiet --batch --yes \
    --passphrase-fd 0 --decrypt \
    --output "$etcdir/$oci_key_filename" \
    ./etc/$oci_key_filename.gpg && echo "✅ oracle key decrypted"

# Decrypt Oracle cloud config file into local credential dir using a passphrase, 
echo -e "$PASSWORD_FOR_GPG_FILES" | gpg \
    --quiet --batch --yes \
    --passphrase-fd 0 --decrypt \
    --output "$etcdir/$oci_config_filename" \
    ./etc/$oci_config_filename.gpg && echo "✅ oracle config file decrypted"

