#!/bin/bash
dirpath=$(dirname $(which $0))
cd $dirpath/..

mkdir -p log var

echo "Choose a profile (dev|test|prod) [dev] ? "
read profile

if [ -z $profile ]
then
    profile="dev"
fi

if [ $profile != "prod" ] && [ $profile != "dev" ] && [ $profile != "test" ]
then 
    echo "Profile chosen is wrong"
    exit -1
fi


export GOOGLE_APPLICATION_CREDENTIALS="/etc/brushed-charts/credentials/backend-institution_account-service.json"
export OANDA_API_URL="https://api-fxpractice.oanda.com"
export OANDA_BIGQUERY_SHORTTERM_TABLENAME="price_shortterm"
export OANDA_BIGQUERY_ARCHIVE_TABLENAME="price_archive"
export OANDA_BIGQUERY_DATASET="oanda_$profile"
export OANDA_WATCHLIST_PATH="resources/oanda_watchlist.txt"
export OANDA_LATEST_CANDLE_PATH="var/latest_candles.json"

#./scripts/prestart.sh || exit -1

(go run . > log/oanda-$profile.log 2>&1 ; rm var/PID-oanda-$profile) &

oanda_PID=$!
echo $oanda_PID > var/PID-oanda-$profile
echo "started with PID : $oanda_PID"