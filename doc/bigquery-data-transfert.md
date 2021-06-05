# Transfert BigQuery data to a table with a different structure in other location

## Abstract
Transfert data in a different table with some structure variation is not an easy task. We will use a temporary table and a query to fill the destination table.

## Process
- Copy the source table to a dataset in a 'temparary' table in the same location as the destination table. This step is required because insertion query between two tables in different location is curretly prohibed. To copy data it may be usefull to use the **export to Google Cloud Storage** function. Export it as json to handle nested data. And for table that weight more than 1Go use the `*` in file name. eg: `xxx-*.json`
- Use the following query to insert data from the temporary table to the destination one. 
```sql
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
```
- Don't forget to delete the temporary data.