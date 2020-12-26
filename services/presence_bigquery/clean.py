import pymongo
import os
from typing import List, Dict
from datetime import datetime, timedelta
from bson import objectid

HOST=os.getenv("MONGODB_HOST")
PORT=os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_OANDA_DBNAME")
COLLECTION = os.getenv("MONGODB_OANDA_PRESENCE_LAST_UPDATE_COLLECTION")
DAYS_CLEAN_FROM = os.getenv("CLEAN_PRESENCE_FROM_N_DAYS")


def delete_old():
    date_clean_from = make_date_limit()
    client = connect()
    collection = get_collection(client)
    request_filter = make_filter(date_clean_from)
    collection.delete_many(request_filter)
    disconnect(client)


def make_date_limit() -> datetime:
    now = datetime.utcnow()
    date_limit = now - timedelta(days=int(DAYS_CLEAN_FROM))

    return date_limit


def connect() -> pymongo.MongoClient:
    client = pymongo.MongoClient(host=HOST, port=int(PORT))
    
    return client


def get_collection(client: pymongo.MongoClient):
    database = client.get_database(DATABASE)
    collection = database.get_collection(COLLECTION)
    
    return collection


def make_filter(date: datetime) -> Dict:
    parsed_date = str(date).replace(" ", "T")
    request_filter = {"date": {"$lt": parsed_date}}

    return request_filter


def disconnect(client: pymongo.MongoClient):
    client.close()