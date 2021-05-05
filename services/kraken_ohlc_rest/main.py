from google.cloud import error_reporting as greport
from price_response import PriceResponse

import itertools
import pymongo
import watchlist
import requests
import traceback
import time
import os
import database

SERVICE_NAME = os.getenv("SERVICE_NAME")
ENVIRONMENT = os.getenv("BRUSHED_CHARTS_ENVIRONMENT")
URL = "https://api.kraken.com/0/public/OHLC"
DELAY = 3 # seconds
INTERVALS = [1, 60, 1440]

global asset_pairs
global parameters


def save_to_database(raw_response: str, pair: str, interval: int):
    response = PriceResponse(raw_response, pair, interval)
    data_to_insert = response.data
    database.insert_all(data_to_insert)


def fetch(interval: int, pair: str) -> str:
    query = f'{URL}?pair={pair}&interval={interval}'
    response = requests.get(query)
    response.raise_for_status()

    return response.text


def start_loop():
    for parameter in parameters:
        interval, pair = parameter
        str_response = fetch(interval, pair)
        save_to_database(str_response, pair, interval)
        time.sleep(DELAY)


def try_execute():
    try:
        start_loop()
    except:
        traceback.print_exc()
        if(ENVIRONMENT == 'dev'): return
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
        time.sleep(DELAY)
