#!/bin/bash

dir="$(dirname $(which $0))"
cd $dir

function create {
    bq mk -t \
    --expiration 0 \
    --time_partitioning_field date \
    --time_partitioning_type=DAY \
    --time_partitioning_expiration $2 \
    --require_partition_filter \
    --clustering_fields granularity,instrument \
    $1 \
    ./candle_bidask_shemas.json
}
bq ls oanda_prod || bq mk oanda_prod
create "oanda_prod.price_archive" 315400000 # 10 years

bq ls oanda_test || bq mk oanda_test
create "oanda_test.price_archive" 5256000 # 2 months

bq ls oanda_dev || bq mk oanda_dev
create "oanda_dev.price_archive" 1210000 # 2 weeks