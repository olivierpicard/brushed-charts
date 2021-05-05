from google.cloud import error_reporting as greport
import itertools

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


def fetch(interval: int, pair: str):
    query = f'{URL}?pair={pair}&interval={interval}'
    response = requests.get(query)
    response.raise_for_status()

    return response.text


def start_loop():
    for parameter in parameters:
        interval, pair = parameter
        fetch(interval, pair)
        time.sleep(DELAY)


def try_execute():
    try:
        start_loop()
    except:
        traceback.print_exc()
        client = greport.Client(service=f'{SERVICE_NAME}.{ENVIRONMENT}')
        client.report_exception()


def build_parameters():
    return list(itertools.product(INTERVALS, asset_pairs))


if __name__ == "__main__":
    global asset_pairs, parameters
    asset_pairs = watchlist.get_asset_pairs()
    parameters = build_parameters()

    while True:
        try_execute()
