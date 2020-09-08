#!/bin/bash

function create {
    bq mk -t \
    --expiration 0 \
    --time_partitioning_field date \
    --time_partitioning_type=DAY \
    --time_partitioning_expiration $2 \
    --require_partition_filter \
    --clustering_fields interval,instrument \
    $1 \
    ./candle_bidask_shemas.json
}

create "oanda_prod.price_archive" 315400000 # 10 years
create "oanda_dev.price_archive" 1210000 # 2 weeks