import pymongo
import os
from typing import List, Dict
from datetime import datetime


HOST=os.getenv("MONGODB_HOST")
PORT=os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_OANDA_DBNAME")
COLLECTION_NAME = os.getenv("MONGODB_MAIL_COLLECTION")
EMAIL_ADDRESS = os.getenv("ADMIN_EMAIL_ADDRESS")
REFRESH_RATE = os.getenv("PRESENCE_REFRESH_RATE_SECONDS")  # In seconds
BIGQUERY_TABLE_PATH = os.getenv("BIGQUERY_TABLE_PATH_TO_MONITOR_PRESENCE")


def email_on_no_presence(presences: List):
    if len(presences) != 0:
        return
    client = connect()
    collection = get_collection(client)
    insert_mail_data(collection)
    disconnect(client)


def connect() -> pymongo.MongoClient:
    client = pymongo.MongoClient(host=HOST, port=int(PORT))
    
    return client


def get_collection(client: pymongo.MongoClient):
    database = client.get_database(DATABASE)
    collection = database.get_collection(COLLECTION_NAME)
    
    return collection


def insert_mail_data(collection: pymongo.collection.Collection):
    subject = "No data for {}".format(BIGQUERY_TABLE_PATH)
    body = "No data in {} for more than {} seconds".format(BIGQUERY_TABLE_PATH, REFRESH_RATE)
    collection.insert_one({
        "frequency": 86400,
        "from": EMAIL_ADDRESS,
        "to": EMAIL_ADDRESS,
        "at": str(datetime.utcnow()).replace(" ", "T"),
        "subject": subject,
        "body": body
    })


def disconnect(client: pymongo.MongoClient):
    client.close()