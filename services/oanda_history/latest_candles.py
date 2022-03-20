import os
import pymongo
from typing import List

HOST=os.getenv("MONGODB_HOST")
PORT=os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_OANDA_DBNAME")
COLLECTION = os.getenv("MONGODB_OANDA_LATEST_CANDLES_COLLECTION")

def get_all_documents():
    client = connect()
    collection = get_collection(client)
    all_documents = list(collection.find())
    disconnect(client)

    return all_documents


def connect() -> pymongo.MongoClient:
    client = pymongo.MongoClient(host=HOST, port=int(PORT))

    return client


def disconnect(client: pymongo.MongoClient):
    client.close()


def get_collection(client: pymongo.MongoClient):
    database = client.get_database(DATABASE)
    collection = database.get_collection(COLLECTION)

    return collection