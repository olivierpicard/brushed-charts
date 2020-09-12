#!/bin/bash

dirpath=$(dirname $(which $0))
cd "$dirpath"/..

export BCBPATH=$PWD # Brushed-Charts base path
export GOOGLE_APPLICATION_CREDENTIALS="/etc/brushed-charts/credentials/backend-institution_account-service.json"

echo -n "Choose a profile (dev|test|prod) [dev]: "
read -r profil
if [ -z $profil ]
then
    profil="dev"
fi 

if [ ! -f $GOOGLE_APPLICATION_CREDENTIALS ]
then 
    echo "Decrypting google credential..."
    ./scripts/decrypt.sh
fi 

echo "Building go logexit application..."
cd tools/logexit
mkdir -p bin
go build -o bin/ .
cd $BCBPATH

echo "Starting 'oanda' application"
cd institutions/oanda/
./scripts/start.sh $profil


echo "Start watching for oanda to report when the app exit"
pid=$(cat "var/PID-oanda-$profil")
cd $BCBPATH
./tools/logexit/bin/logexit "brushed-charts" $pid "oanda" &
