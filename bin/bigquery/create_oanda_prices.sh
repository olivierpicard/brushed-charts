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
        ./oanda_prices_schema.json
}

bq ls prod || bq --location=EU mk prod
create "prod.oanda_prices" 315400000  # 10 years

bq ls "test" || bq --location=EU mk "test"
create "test.oanda_prices" 5256000 # 2 months

bq ls dev || bq --location=EU mk dev
create "dev.oanda_prices" 1210000  # 2 weeks