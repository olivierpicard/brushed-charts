import time
import os
import lastupdate_log
import history
import traceback

from datetime import datetime, timedelta
from google.cloud import bigquery, error_reporting


REFRESH_RATE = 30  # In seconds
PATH_PRICE_TABLE = os.getenv("KRAKEN_BIGQUERY_PATH_OHLC_TABLE")
ENVIRONMENT = os.getenv("BRUSHED_CHARTS_ENVIRONMENT")
UPPER_BOUND_DELAY = 3  # minutes
WINDOW_LIMIT = int(os.getenv('KRAKEN_BQ_SEND_WINDOW_MAX_SIZE'))  # seconds


class EmptyCandles(Exception):
    pass


def raise_if_candles_empty(candles: list):
    if candles is None or len(candles) == 0:
        raise EmptyCandles


def send_to_bigquery(candles: list):
    client = bigquery.Client()
    client.insert_rows_json(PATH_PRICE_TABLE, candles)
    client.close()


def make_time_window():
    lower_window = lastupdate_log.read()
    current_time = datetime.utcnow()
    upper_window = current_time - timedelta(minutes=UPPER_BOUND_DELAY)
 
    return (lower_window, upper_window)


def execute():
    time_window = make_time_window()
    upper_window = time_window[1]
    candles = history.get_candles_from_window(time_window)
    raise_if_candles_empty(candles)
    send_to_bigquery(candles)
    lastupdate_log.save_last_reading_date(upper_window)


def try_to_execute():
    try:
        execute()
    except EmptyCandles:
        pass
    except Exception:
        traceback.print_exc()
        error_reporting.Client(service="kraken_ohlc_bigquery." +
                               ENVIRONMENT).report_exception()


if __name__ == "__main__":
    while True:
        try_to_execute()
        time.sleep(REFRESH_RATE)
