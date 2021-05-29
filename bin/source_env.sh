#!/bin/zsh

#-----------------------------
# Author: Olivier PICARD
# Abstract: Add dev environment variables in the current shell
# Usage: source ./source_env.sh 
# Note: Don't forget the './' when calling this script
#-----------------------------


origin=`pwd`
dirpath=$(dirname $(which $0))
cd $dirpath/../env

set -o allexport
source presence_shortterm.env
source services.env
source services.dev.env
source secrets.env
set +o allexport

cd $origin