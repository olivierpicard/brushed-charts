#!/bin/bash

dir="$(dirname $(which $0))"
cd $dir

function create {
    # Table expiration 5 month. 
    bq mk -t \
        --expiration 0 \
        --time_partitioning_field date \
        --time_partitioning_type=HOUR \
        --time_partitioning_expiration "$2" \
        --require_partition_filter \
        --clustering_fields interval,instrument \
        "$1" \
        ./candle_bidask_shemas.json
}

bq ls oanda_prod || bq mk oanda_prod
create "oanda_prod.price_shortterm" 13140000 # 5 months

bq ls oanda_test || bq mk oanda_test
create "oanda_test.price_shortterm" 5256000 # 2 months

bq ls oanda_dev || bq mk oanda_dev
create "oanda_dev.price_shortterm" 1210000 # 2 weeks

