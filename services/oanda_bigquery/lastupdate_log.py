import pymongo
import os
from datetime import datetime
from typing import List, Dict


HOST = os.getenv("MONGODB_HOST")
PORT = os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_OANDA_DBNAME")
COLLECTION = os.getenv("MONGODB_OANDA_BIGQUERY_SAVE_DATE_COLLECTION")
NO_DATE = datetime.fromtimestamp(0)


def read() -> datetime:
    client = connect()
    database = client.get_database(DATABASE)
    collection = database.get_collection(COLLECTION)
    document = collection.find_one({})
    last_update = NO_DATE
    if document != None:
        last_update = document['last_update']
    disconnect(client)

    return last_update


def save_last_reading_date(date: datetime):
    client = connect()
    reset_collection(client)
    update(client, date)
    
    
def connect() -> pymongo.MongoClient:
    client = pymongo.MongoClient(host=HOST, port=int(PORT))
    
    return client


def reset_collection(client: pymongo.MongoClient):
    database = client.get_database(DATABASE)
    database.drop_collection(COLLECTION)


def update(client: pymongo.MongoClient, date: datetime):
    database = client.get_database(DATABASE)
    collection = database.get_collection(COLLECTION)
    collection.insert_one({"last_update": date})


def disconnect(client: pymongo.MongoClient):
    client.close()