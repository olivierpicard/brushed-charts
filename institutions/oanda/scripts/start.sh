#!/bin/bash
dirpath=$(dirname $(which $0))
cd $dirpath/..
export GOOGLE_APPLICATION_CREDENTIALS="/etc/brushed-charts/credentials/backend-institution_account-service.json"
export OANDA_API_URL="https://api-fxpractice.oanda.com"
export OANDA_BIGQUERY_SHORTTERM_TABLENAME="price_shortterm"
export OANDA_BIGQUERY_ARCHIVE_TABLENAME="price_archive"
export OANDA_BIGQUERY_DATASET="oanda_dev"
export OANDA_WATCHLIST_PATH="./resources/oanda_watchlist.txt"

#go run $src > "$src"/../../logs/oanda.log 2>&1 
#oanda_PID=$!
#echo $oanda_PID > ./var/PID
mkdir -p var 
mkdir -p ../../logs
go run .