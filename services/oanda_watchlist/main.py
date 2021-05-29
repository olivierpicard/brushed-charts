import os
import time
import parser
import traceback
import pymongo
from db import DatabaseUpdater
from google.cloud import error_reporting

HOST = os.getenv("MONGODB_HOST")
PORT = os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_OANDA_DBNAME")
COLLECTION = os.getenv("MONGODB_OANDA_WATCHLIST_COLLECTION")
WATCHLIST_PATH = os.getenv('OANDA_WATCHLIST_PATH')
REFRESH_RATE = 60 * 5  # In seconds
ENVIRONMENT = os.getenv("BRUSHED_CHARTS_ENVIRONMENT")


def execute():
    instruments = parser.get_instruments_from_watchlist(WATCHLIST_PATH)
    database.update(instruments)


def try_execute():
    try:
        execute()
    except pymongo.errors.DuplicateKeyError:
        pass
    except Exception:
        traceback.print_exc()
        error_reporting.client.Client(
            service="oanda_watchlist."+ENVIRONMENT).report_exception()


if __name__ == "__main__":
    database = DatabaseUpdater(HOST, PORT, DATABASE, COLLECTION)
    while True:
        try_execute()
        time.sleep(REFRESH_RATE)
