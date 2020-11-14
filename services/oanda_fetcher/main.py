import os
import re
import requests
import time

from fetcher import Fetcher
import watchlist
import candles_saver

ACCOUNT_ID = os.getenv('OANDA_ACCOUNT_ID')
TOKEN = os.getenv('OANDA_API_TOKEN')
API_URL = os.getenv('OANDA_API_URL')
URL_LATEST_CANDLE = API_URL + "/v3/accounts/" + ACCOUNT_ID + "/candles/latest"
GRANULARITIES = ["S5", "M1", "H1", "D"]
REFRESH_RATE = 1


if __name__ == "__main__":
    while True:
        fetcher = Fetcher(token=TOKEN, url_path=URL_LATEST_CANDLE, granularities=GRANULARITIES)
        instruments = watchlist.get_instruments()
        latest_candles = fetcher.get_latest_candles(instruments)
        candles_saver.save(latest_candles)
        time.sleep(REFRESH_RATE)

    