#!/bin/bash

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

create "oanda_prod.price_shortterm" 13140000 # 5 months
create "oanda_dev.price_shortterm" 1210000 # 2 weeks

