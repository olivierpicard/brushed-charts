#!/bin/bash

dir="$(dirname $(which $0))"
cd $dir

function create { 
    bq mk -t \
        --expiration 0 \
        --time_partitioning_field date \
        --time_partitioning_type=HOUR \
        --time_partitioning_expiration "$2" \
        --require_partition_filter \
        --clustering_fields granularity,instrument \
        "$1" \
        ./candle_bidask_shemas.json
}

bq ls oanda_automatedtest || bq mk oanda_automatedtest
create "oanda_automatedtest.price_shortterm" 60 # 1 minute
create "oanda_automatedtest.price_archive" 60 # 1 minute

