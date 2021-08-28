CREATE OR REPLACE TABLE FUNCTION `brushed-charts.prod.kraken_ohlc_interval`(seconds INT64, lower_bound ANY TYPE, upper_bound ANY TYPE) RETURNS TABLE<datetime TIMESTAMP, asset_pair STRING, granularity INT64, open FLOAT64, high FLOAT64, low FLOAT64, close FLOAT64, trade_count INT64, volume FLOAT64, vwap FLOAT64> AS (
    SELECT 
            asset_pair,
            granularity,
            CAST( FLOOR( UNIX_MILLIS(datetime)/(seconds*1000)) AS INT64) AS rounded_timestamp,
            ARRAY_AGG(open ORDER BY datetime LIMIT 1)[OFFSET(0)] AS open,
            ARRAY_AGG(close ORDER BY datetime DESC LIMIT 1)[OFFSET(0)] AS close,
            ARRAY_AGG(vwap ORDER BY datetime DESC LIMIT 1)[OFFSET(0)] AS vwap,
            MIN(datetime) AS datetime,
            MAX(high) AS high,
            MIN(low) AS low,
            SUM(volume) as volume,
            SUM(trade_count) AS trade_count,
    FROM `brushed-charts.prod.kraken_ohlc` 
    WHERE 
        datetime >= lower_bound AND datetime < upper_bound
    GROUP BY rounded_timestamp, asset_pair, granularity
    ORDER BY rounded_timestamp
);