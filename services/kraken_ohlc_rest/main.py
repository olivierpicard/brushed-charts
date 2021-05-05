from google.cloud import error_reporting as greport

import watchlist
import requests
import traceback
import time
import os


SERVICE_NAME = os.getenv("SERVICE_NAME")
ENVIRONMENT = os.getenv("ENVIRONMENT")
URL = "https://api.kraken.com/0/public/OHLC"
DELAY = 3  # seconds
INTERVALS = [1, 60, 1440]

global asset_pairs
global parameters


def fetch(pair: str, interval: int):
    query = f'{URL}?pair={pair}&interval={interval}'
    response = requests.get(query)
    response.raise_for_status()

    return response.text


def loop_on_pairs():
    for pair in asset_pairs:
        fetch(pair=pair, interval=1)
        time.sleep(DELAY)


def loop_on_interval():
    for interval in INTERVALS:
        loop_on_pairs()


def start_fetch_looping():
    try:
        loop_on_interval()
    except:
        traceback.print_exc()
        client = greport.Client(service=f'{SERVICE_NAME}.{ENVIRONMENT}')
        client.report_exception()


def build_parameters():
    return [(interval, pair) for interval in INTERVALS for pair in asset_pairs]

if __name__ == "__main__":
    global asset_pairs, parameters
    asset_pairs = watchlist.get_asset_pairs()
    parameters = build_parameters()
    while True:
        try_execute()
