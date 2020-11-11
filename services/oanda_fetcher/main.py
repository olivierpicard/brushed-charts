from fetcher import Fetcher
import requests
import os
import re
from google.cloud import error_reporting

ACCOUNT_ID = os.getenv('OANDA_ACCOUNT_ID')
TOKEN = os.getenv('OANDA_API_TOKEN')
API_URL = os.getenv('OANDA_API_URL')
GRANULARITIES = ["S5", "M1", "H1", "D"]
URL_LATEST_CANDLE = API_URL + "/v3/accounts/" + ACCOUNT_ID + "/candles/latest"

if __name__ == "__main__":
    fetcher = Fetcher(token=TOKEN, url_path=URL_LATEST_CANDLE, granularities=GRANULARITIES)
    r = fetcher.fetch(["EUR_USD"])
    