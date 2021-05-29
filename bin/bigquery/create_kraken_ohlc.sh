#!/bin/bash

dir="$(dirname $(which $0))"
cd $dir

function create { 
    bq mk -t \
        --expiration 0 \
        --time_partitioning_field datetime \
        --time_partitioning_type=DAY \
        --time_partitioning_expiration "$2" \
        --require_partition_filter \
        --clustering_fields asset_pair,granularity \
        "$1" \
        ./kraken_ohlc_schema.json
}

bq ls prod > /dev/null || bq --location=EU mk prod
create "prod.kraken_ohlc" 315400000  # 10 years

bq ls "test" > /dev/null || bq --location=EU mk "test"
create "test.kraken_ohlc" 5256000 # 2 months

bq ls dev > /dev/null || bq --location=EU mk dev
create "dev.kraken_ohlc" 1210000  # 2 weeks