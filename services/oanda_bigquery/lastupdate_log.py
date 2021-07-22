import pymongo
import os
from datetime import datetime, timedelta


HOST = os.getenv("MONGODB_HOST")
PORT = os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_OANDA_DBNAME")
COLLECTION = os.getenv("MONGODB_OANDA_BIGQUERY_SAVE_DATE_COLLECTION")
FOUR_HOUR_EARLIER = datetime.utcnow() - timedelta(hours=4)


def read() -> datetime:
    client = connect()
    database = client.get_database(DATABASE)
    collection = database.get_collection(COLLECTION)
    document = collection.find_one()
    last_update = FOUR_HOUR_EARLIER
    if document is not None:
        last_update = document['last_update']
    disconnect(client)

    return last_update


def save_last_reading_date(date: datetime):
    client = connect()
    update(client, date)


def connect() -> pymongo.MongoClient:
    client = pymongo.MongoClient(host=HOST, port=int(PORT))
    return client


def update(client: pymongo.MongoClient, date: datetime):
    database = client.get_database(DATABASE)
    collection = database.get_collection(COLLECTION)
    collection.update_one({}, {"$set": {"last_update": date}}, upsert=True)


def disconnect(client: pymongo.MongoClient):
    client.close()
