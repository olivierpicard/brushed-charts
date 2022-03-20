import time
import latest_candles
import candle_parser
import history
import traceback
import os

from google.cloud import error_reporting
from typing import List, Dict

REFRESH_RATE = 5  # In seconds
ENVIRONMENT = os.getenv("BRUSHED_CHARTS_ENVIRONMENT")


class EmptyCandles(Exception): pass


def add_to_history():
    latestcandles = latest_candles.get_all_documents()
    candles = candle_parser.flatten_all(latestcandles)
    candles = candle_parser.remove_incomplete_candle(candles)
    candle_parser.change_fieldname_time_with_date(candles)
    raise_for_empty_candles(candles)
    history.insert_all(candles)


def raise_for_empty_candles(candles: List[Dict]):
    if candles is None or len(candles) == 0:
        raise EmptyCandles


def try_execute():
    try:
        add_to_history()
    except EmptyCandles:
        pass
    except Exception:
        traceback.print_exc()
        error_reporting.Client(service="oanda_history."+ENVIRONMENT).report_exception()


if __name__ == "__main__":
    while True:
        try_execute()
        time.sleep(REFRESH_RATE)
