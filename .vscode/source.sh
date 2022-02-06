#!/bin/bash

####################################
# Start this script using the command source. Like this: 
# source .vscode/source.sh
####################################

dirpath=$(dirname $(which $0))

set -o allexport
source $dirpath/.env
set +o allexport