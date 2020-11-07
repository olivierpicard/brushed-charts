#!/bin/bash

dir="$(dirname $(which $0))"
cd $dir

bq rm -r -f oanda_automatedtest