import pymongo
import os
from datetime import datetime

HOST = os.getenv("MONGODB_HOST")
PORT = os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_KRAKEN_DBNAME")
COLLECTION_NAME = os.getenv("MONGODB_KRAKEN_OHLC_COLLECTION")


def delete_old(from_datetime: datetime):
    client = connect()
    collection = get_collection(client)
    request_filter = make_filter(from_datetime)
    collection.delete_many(request_filter)
    disconnect(client)


def connect() -> pymongo.MongoClient:
    client = pymongo.MongoClient(host=HOST, port=int(PORT))
    
    return client


def get_collection(client: pymongo.MongoClient):
    database = client.get_database(DATABASE)
    collection = database.get_collection(COLLECTION_NAME)
    
    return collection


def make_filter(date: datetime) -> dict:
    parsed_date = str(date).replace(" ", "T")
    request_filter = {"datetime": {"$lt": parsed_date}}

    return request_filter


def disconnect(client: pymongo.MongoClient):
    client.close()
