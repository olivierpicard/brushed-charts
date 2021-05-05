import pymongo
import os
from typing import List

HOST = os.getenv("MONGODB_HOST")
PORT = os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_OANDA_DBNAME")
COLLECTION = os.getenv("MONGODB_OANDA_LATEST_CANDLES_COLLECTION")


def save(candles: List[str]):
    client = connect_to_database()
    collection = get_reseted_collection(client)
    collection.insert_many(candles)
    disconnect(client)


def connect_to_database() -> pymongo.database.Database :
    client = pymongo.MongoClient(host=HOST, port=int(PORT))

    return client


def get_reseted_collection(client: pymongo.MongoClient) -> pymongo.collection.Collection :
    database = client.get_database(name=DATABASE)
    collection = database.get_collection(name=COLLECTION)
    collection.delete_many({})
    return collection


def disconnect(client: pymongo.MongoClient):
    client.close()