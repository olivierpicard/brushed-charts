/* Transfert data to a table with a different structure */

INSERT INTO 
    prod.oanda_prices (date, granularity, instrument, bid, ask, volume, mid)
SELECT 
    date, granularity, instrument, 
    STRUCT(bid.open, bid.high, bid.low, bid.close),
    STRUCT(ask.open, ask.high, ask.low, ask.close), 
    volume,
    STRUCT(
        ROUND((ask.open + bid.open)/2, 5) AS open,
        ROUND((ask.high + bid.high)/2, 5) AS high,
        ROUND((ask.low + bid.low)/2, 5) AS low,
        ROUND((ask.close + bid.close)/2, 5) AS close
    ) AS mid
FROM `brushed-charts.prod.oanda_temp`
WHERE date > "2019-05-28"
ORDER BY date DESC