import os
import pymongo
from datetime import datetime
from typing import List
from bson import objectid


HOST=os.getenv("MONGODB_HOST")
PORT=os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_OANDA_DBNAME")
COLLECTION = os.getenv("MONGODB_OANDA_LATEST_CANDLES_COLLECTION")


def get_candles_from_date(date: datetime):
    client = connect()
    collection = get_collection(client)
    documents = list(select_documents_after(date, collection))
    disconnect(client)

    return documents


def connect() -> pymongo.MongoClient:
    client = pymongo.MongoClient(host=HOST, port=int(PORT))

    return client


def get_collection(client: pymongo.MongoClient):
    database = client.get_database(DATABASE)
    collection = database.get_collection(COLLECTION)

    return collection


def select_documents_after(date: datetime, collection: pymongo.collection.Collection) -> pymongo.cursor.Cursor:
    objectID = make_objectid_from_date(date)
    time_criteria = {"_id": {"$gt": objectID}}
    cursor = collection.find(time_criteria)
    return cursor


def make_objectid_from_date(date: datetime) -> objectid.ObjectId:
    objectID = objectid.ObjectId.from_datetime(date)
    return objectID


def disconnect(client: pymongo.MongoClient):
    client.close()