import time
import latest_candles
import candle_parser
import history
from google.cloud import error_reporting
from typing import List, Dict

REFRESH_RATE = 5  # In seconds

class EmptyCandles(Exception): pass


def add_to_history():
    latestcandles = latest_candles.get_all_documents()
    candles = candle_parser.flatten_all(latestcandles)
    candles = candle_parser.remove_incomplete_candle(candles)
    candle_parser.change_fieldname_time_with_date(candles)
    raise_for_empty_candles(candles)
    history.insert_all(candles)


def raise_for_empty_candles(candles: List[Dict]):
    if candles == None or len(candles) == 0:
        raise EmptyCandles


def try_execute():
    try:
        add_to_history()
    except EmptyCandles:
        pass
    except Exception as e:
        print(e)
        error_reporting.Client(service="oanda_history").report_exception()


if __name__ == "__main__":
    while True:
        try_execute()
        time.sleep(REFRESH_RATE)