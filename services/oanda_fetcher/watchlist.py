import json
import os

OANDA_WATCHLIST_PATH = os.getenv('OANDA_WATCHLIST_PATH')


def load_config():
    file = open(OANDA_WATCHLIST_PATH)
    data = json.load(file)
    file.close()
    return data

raw_data = load_config()
pairs = raw_data['pairs']
del raw_data