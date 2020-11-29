import time
import latest_candles
import candle_parser
import history
from google.cloud import error_reporting
from typing import List, Dict

REFRESH_RATE = 5  # In seconds


def add_to_history():
    latestcandles = latest_candles.get_all_documents()
    candles = candle_parser.flatten_all(latestcandles)
    candles = candle_parser.remove_incomplete_candle(candles)
    candle_parser.change_fieldname_time_with_date(candles)
    history.insert_all(candles)


def try_execute():
    try:
        add_to_history()
    except Exception as e:
        print(e)
        error_reporting.Client().report_exception()


if __name__ == "__main__":
    while True:
        try_execute()
        time.sleep(REFRESH_RATE)