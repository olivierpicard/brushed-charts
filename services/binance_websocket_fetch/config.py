import json
import os

BINANCE_WATCHLIST_PATH = os.getenv('BINANCE_WATCHLIST_PATH')


def load_config():
    file = open(BINANCE_WATCHLIST_PATH)
    data = json.load(file)
    file.close()
    return data

raw_data = load_config()
pairs = raw_data['pairs']
stream_types = raw_data['stream_types']