CREATE OR REPLACE TABLE FUNCTION `brushed-charts.prod.oanda_prices_interval`(seconds INT64, lower_bound ANY TYPE, upper_bound ANY TYPE) AS (
    SELECT * EXCEPT(rounded_timestamp)  FROM(
        SELECT 
                MIN(`date`) AS `date`,
                instrument,
                granularity,
                CAST( FLOOR( UNIX_MILLIS(`date`)/(seconds*1000)) AS INT64) AS rounded_timestamp,
                STRUCT(
                    ARRAY_AGG( mid.open ORDER BY `date` LIMIT 1)[OFFSET(0)] AS open,
                    MAX(mid.high) AS high,
                    MIN(mid.low) AS low,
                    ARRAY_AGG( mid.close ORDER BY `date` DESC LIMIT 1)[OFFSET(0)] AS close
                ) AS mid,
                STRUCT(
                    ARRAY_AGG( bid.open ORDER BY `date` LIMIT 1)[OFFSET(0)] AS open,
                    MAX(bid.high) AS high,
                    MIN(bid.low) AS low,
                    ARRAY_AGG( bid.close ORDER BY `date` DESC LIMIT 1)[OFFSET(0)] AS close
                ) AS bid,
                STRUCT(
                    ARRAY_AGG( ask.open ORDER BY `date` LIMIT 1)[OFFSET(0)] AS open,
                    MAX(ask.high) AS high,
                    MIN(ask.low) AS low,
                    ARRAY_AGG( ask.close ORDER BY `date` DESC LIMIT 1)[OFFSET(0)] AS close
                ) AS ask,
                SUM(volume) as volume,
        FROM `brushed-charts.prod.oanda_prices` 
        WHERE 
            `date` >= lower_bound AND `date` < upper_bound
        GROUP BY rounded_timestamp, instrument, granularity
        ORDER BY rounded_timestamp
    )
);