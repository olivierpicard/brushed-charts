#!/bin/bash

# Table expiration 10 years. 
bq mk -t \
--expiration 0 \
--time_partitioning_field date \
--time_partitioning_type=HOUR \
--time_partitioning_expiration 13140000 \
--require_partition_filter \
--clustering_fields interval,instrument \
oanda.price_shortterm \
./candle_bidask_shemas.json
