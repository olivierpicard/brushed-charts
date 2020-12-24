import os
import time
import parser
from db import DatabaseUpdater
from google.cloud import error_reporting

HOST = os.getenv("MONGODB_HOST")
PORT = os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_OANDA_DBNAME")
COLLECTION = os.getenv("MONGODB_OANDA_WATCHLIST_COLLECTION")
WATCHLIST_PATH = os.getenv('OANDA_WATCHLIST_PATH')
REFRESH_RATE = 60 * 5  # In seconds


def execute():
    instruments = parser.get_instruments_from_watchlist(WATCHLIST_PATH)
    database.update(instruments)


def try_execute():
    try:
        execute()
    except Exception as e:
        print(e)
        error_reporting.client.Client(service="oanda_watchlist").report_exception()


if __name__ == "__main__":
    database = DatabaseUpdater(HOST, PORT, DATABASE, COLLECTION)
    while True:
        try_execute()
        time.sleep(REFRESH_RATE)
