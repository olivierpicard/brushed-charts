import pymongo
import os
from datetime import datetime, timedelta
from typing import List, Dict


HOST = os.getenv("MONGODB_HOST")
PORT = os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_OANDA_DBNAME")
COLLECTION = os.getenv("MONGODB_OANDA_LAST_EMAIL_SENT_DATE_COLLECTION")
BIGQUERY_TABLE_PATH = os.getenv("BIGQUERY_TABLE_PATH_TO_MONITOR_PRESENCE")
REFRESH_RATE = os.getenv("PRESENCE_REFRESH_RATE_SECONDS")  # In seconds
SUBJECT = "presence " + BIGQUERY_TABLE_PATH
DUPLICATION_KEY_ERROR = 11000

def is_ready_to_send_mail() -> bool:
    client = connect()
    collection = get_collection(client)
    document = collection.find_one({"subject": SUBJECT})
    disconnect(client)
    if document == None:
        return True
    last_sent_date = document['date']
    delta = datetime.utcnow() - last_sent_date
    if delta.total_seconds() > int(REFRESH_RATE):
        return True
    
    return False


def save():
    client = connect()
    collection = get_collection(client)
    create_index(collection)
    upsert(collection)
    
    
def connect() -> pymongo.MongoClient:
    client = pymongo.MongoClient(host=HOST, port=int(PORT))
    
    return client


def get_collection(client):
    database = client.get_database(DATABASE)
    collection = database.get_collection(COLLECTION)
    
    return collection


def create_index(collection: pymongo.collection.Collection):
    collection.create_index([("bigquery_path",1)], unique=True)


def upsert(collection: pymongo.collection.Collection):
    try:
        collection.delete_many({"subject": SUBJECT})
        collection.insert_one({
            "date": datetime.utcnow(),
            "subject": SUBJECT
        })
    except pymongo.errors.BulkWriteError as e:
        panic_list = list(filter(lambda x: x['code'] != DUPLICATION_KEY_ERROR, e.details['writeErrors']))
        if len(panic_list) > 0:
            raise e


def disconnect(client: pymongo.MongoClient):
    client.close()