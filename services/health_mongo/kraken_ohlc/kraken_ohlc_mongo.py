import pymongo
import os
from datetime import datetime


HOST = os.getenv("MONGODB_HOST")
PORT = os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_KRAKEN_DBNAME")
COLLECTION_NAME = os.getenv("MONGODB_KRAKEN_OHLC_COLLECTION")


def read_last_datetime() -> datetime:
    client = _connect()
    collection = _get_collection(client)
    result = _get_last_datetime(collection)
    last_datetime = result_to_datetime(result)
    _disconnect(client)

    return last_datetime


def _connect() -> pymongo.MongoClient:
    client = pymongo.MongoClient(host=HOST, port=int(PORT))

    return client


def _get_collection(client: pymongo.MongoClient):
    database = client.get_database(DATABASE)
    collection = database.get_collection(COLLECTION_NAME)

    return collection


def _get_last_datetime(collection: pymongo.collection.Collection):
    last_datetime = collection.find(
        filter={},
        projection={'datetime': -1, '_id': 0},
        sort=[('datetime', -1)],
        limit=1
    )

    return list(last_datetime)


def result_to_datetime(result: list[str]):
    if len(result) == 0:
        return None
    return datetime.fromisoformat(result[0]['datetime'])

    
    


def _disconnect(client: pymongo.MongoClient):
    client.close()
