import time
import os
import lastupdate_log
from datetime import datetime
from typing import List, Dict
import history
from google.cloud import bigquery, error_reporting


REFRESH_RATE = 10  # In seconds
PATH_TABLE_SHORTTERM = os.getenv("OANDA_BIGQUERY_PATH_TABLE_SHORTTERM")
PATH_TABLE_ARCHIVE = os.getenv("OANDA_BIGQUERY_PATH_TABLE_ARCHIVE")

class EmptyCandles(Exception): pass

def raise_if_candles_empty(candles: List):
    if candles == None or len(candles) == 0:
        raise EmptyCandles


def send_to_bigquery(candles: List):
    client = bigquery.Client()
    client.insert_rows_json(PATH_TABLE_SHORTTERM, candles)
    client.insert_rows_json(PATH_TABLE_ARCHIVE, candles)
    client.close()


def remove_objectID(candles: List[Dict]):
    for candle in candles:
        del candle["_id"]


def execute():
    lastupdate_datetime = lastupdate_log.read()
    current_utc_time = datetime.utcnow()
    candles = history.get_candles_from_date(lastupdate_datetime)
    raise_if_candles_empty(candles)
    remove_objectID(candles)
    send_to_bigquery(candles)
    lastupdate_log.save_last_reading_date(current_utc_time)


def try_to_execute():
    try:
        execute()
    except EmptyCandles:
        pass
    except Exception as e:
        print(e)
        error_reporting.Client(service="oanda_bigquery").report_exception()


if __name__ == "__main__":
    while True:
        try_to_execute()
        time.sleep(REFRESH_RATE)        