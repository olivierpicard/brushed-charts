import pymongo
import os
from typing import List, Dict


HOST=os.getenv("MONGODB_HOST")
PORT=os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_OANDA_DBNAME")
COLLECTION_NAME = os.getenv("MONGODB_OANDA_HISTORY_COLLECTION")


def insert_all(candles: List[Dict]):
    client = connect()
    collection = get_collection(client)
    create_index(collection)
    insertion(collection, candles)
    disconnect(client)


def connect() -> pymongo.MongoClient:
    client = pymongo.MongoClient(host=HOST, port=int(PORT))
    
    return client


def get_collection(client: pymongo.MongoClient):
    database = client.get_database(DATABASE)
    collection = database.get_collection(COLLECTION_NAME)
    
    return collection


def create_index(collection: pymongo.collection.Collection):
    collection.create_index(
        [("date", -1), ("instrument", 1), ("granularity", 1)],
        unique=True
    )


def insertion(collection: pymongo.collection.Collection, candles: List[Dict]):
    try:
        collection.insert_many(candles, ordered=False)
    except pymongo.errors.BulkWriteError as e:
        panic_list = list(filter(lambda x: x['code'] != 11000, e.details['writeErrors']))
        if len(panic_list) > 0:
            raise e


def disconnect(client: pymongo.MongoClient):
    client.close()