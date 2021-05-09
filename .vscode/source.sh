#!/bin/bash

dirpath=$(dirname $(which $0))

set -o allexport
source $dirpath/.env
set +o allexport