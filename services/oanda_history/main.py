import time
import latest_candles
import candle_parser
import history
from google.cloud import error_reporting

REFRESH_RATE = 5  # In seconds


def add_to_history():
    latestcandles = latest_candles.get_all_documents()
    flattened_candles = candle_parser.flatten_all(latestcandles)
    complete_candles = candle_parser.remove_incomplete_candle(flattened_candles)
    history.insert_all(complete_candles)


def try_execute():
    try:
        add_to_history()
    except Exception:
        error_reporting.Client().report_exception()


if __name__ == "__main__":
    while True:
        add_to_history()
        time.sleep(REFRESH_RATE)        