import os
import pymongo
from datetime import datetime

HOST = os.getenv("MONGODB_HOST")
PORT = os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_KRAKEN_DBNAME")
COLLECTION = os.getenv("MONGODB_KRAKEN_OHLC_COLLECTION")


def get_candles_from_window(window: (datetime, datetime)):
    client = connect()
    collection = get_ohlc_collection(client)
    documents = list(select_documents_after(window, collection))
    disconnect(client)

    return documents


def connect() -> pymongo.MongoClient:
    client = pymongo.MongoClient(host=HOST, port=int(PORT))

    return client


def get_ohlc_collection(client: pymongo.MongoClient):
    database = client.get_database(DATABASE)
    collection = database.get_collection(COLLECTION)

    return collection


def select_documents_after(window: (datetime, datetime), collection: pymongo.collection.Collection) -> pymongo.cursor.Cursor:
    lower_window, upper_window = parse_time_window(window)
    time_filter = {"datetime": {"$gt": lower_window, "$lte": upper_window}}
    projection = {"_id": 0}
    cursor = collection.find(time_filter, projection)

    return cursor


def parse_time_window(window: (int, int)):
    parsed_lower_window = str(window[0]).replace(" ", "T")
    parsed_upper_window = str(window[1]).replace(" ", "T")

    return (parsed_lower_window, parsed_upper_window)


def disconnect(client: pymongo.MongoClient):
    client.close()
