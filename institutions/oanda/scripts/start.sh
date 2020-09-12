#!/bin/bash
dirpath=$(dirname $(which $0))
cd $dirpath/..

mkdir -p log var bin

if [ -z $1 ]
then    
    echo -n "Choose a profil (dev|test|prod) [dev]: "
    read -r profil
else
    profil=$1
fi

if [ -z $profil ]
then
    profil="dev"
fi

if [ $profil != "prod" ] && [ $profil != "dev" ] && [ $profil != "test" ]
then 
    echo "profil chosen is wrong"
    exit -1
fi


export GOOGLE_APPLICATION_CREDENTIALS="/etc/brushed-charts/credentials/backend-institution_account-service.json"
export OANDA_API_URL="https://api-fxpractice.oanda.com"
export OANDA_BIGQUERY_SHORTTERM_TABLENAME="price_shortterm"
export OANDA_BIGQUERY_ARCHIVE_TABLENAME="price_archive"
export OANDA_BIGQUERY_DATASET="oanda_$profil"
export OANDA_WATCHLIST_PATH="$PWD/resources/oanda_watchlist.txt"
export OANDA_LATEST_CANDLE_PATH="$PWD/var/latest_candles.json"


go build -o bin .
bin/oanda > log/oanda-$profil.log 2>&1 &

oanda_PID=$!
echo $oanda_PID > var/PID-oanda-$profil
echo "Oanda app started with PID : $oanda_PID"