import os
import pymongo
from datetime import datetime
from typing import List
from bson import objectid


HOST=os.getenv("MONGODB_HOST")
PORT=os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_OANDA_DBNAME")
COLLECTION = os.getenv("MONGODB_OANDA_HISTORY_COLLECTION")


def get_candles_from_date(date: datetime):
    client = connect()
    collection = get_history_collection(client)
    documents = list(select_documents_after(date, collection))
    disconnect(client)

    return documents


def connect() -> pymongo.MongoClient:
    client = pymongo.MongoClient(host=HOST, port=int(PORT))

    return client


def get_history_collection(client: pymongo.MongoClient):
    database = client.get_database(DATABASE)
    collection = database.get_collection(COLLECTION)

    return collection


def select_documents_after(date: datetime, collection: pymongo.collection.Collection) -> pymongo.cursor.Cursor:
    parsed_str_datetime = str(date).replace(" ", "T")
    time_criteria = {"date": {"$gt": parsed_str_datetime}}
    projection_remove_id = {"_id": 0}
    cursor = collection.find(time_criteria, projection_remove_id)

    return cursor


def disconnect(client: pymongo.MongoClient):
    client.close()