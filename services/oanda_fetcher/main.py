import os
import re
import requests
import time
import traceback

from fetcher import Fetcher
from google.cloud import error_reporting
import watchlist
import candles_saver


ACCOUNT_ID = os.getenv('OANDA_ACCOUNT_ID')
TOKEN = os.getenv('OANDA_API_TOKEN')
API_URL = os.getenv('OANDA_API_URL')
URL_LATEST_CANDLE = API_URL + "/v3/accounts/" + ACCOUNT_ID + "/candles/latest"
GRANULARITIES = ["S5", "M1", "H1", "D"]
REFRESH_RATE = 1


def execute():
    fetcher = Fetcher(token=TOKEN, url_path=URL_LATEST_CANDLE, granularities=GRANULARITIES)
    instruments = watchlist.get_instruments()
    latest_candles = fetcher.get_latest_candles(instruments)
    candles_saver.save(latest_candles)


def try_to_execute():
    try:
        execute()
    except Exception:
        traceback.print_exc()
        error_reporting.Client(service="oanda_fetcher").report_exception()


if __name__ == "__main__":
    while True:
        try_to_execute()
        time.sleep(REFRESH_RATE)

    