import pymongo
import os
from bson.objectid import ObjectId
import reference_object as refobj

HOST = os.getenv("MONGODB_HOST")
PORT = os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_KRAKEN_DBNAME")
COLLECTION = os.getenv("MONGODB_KRAKEN_OHLC_BIGQUERY_LAST_SAVE_COLLECTION")


def read() -> ObjectId:
    client = connect()
    database = client.get_database(DATABASE)
    document = refobj.get(database)
    reference_object = document['last_update']
    disconnect(client)

    return reference_object


def save_last_reading_object(candles: list):
    client = connect()
    gtr_object = refobj.get_greatest_item(candles)
    update(client, gtr_object)
    
    
def connect() -> pymongo.MongoClient:
    client = pymongo.MongoClient(host=HOST, port=int(PORT))
    return client


def update(client: pymongo.MongoClient, objectID: ObjectId):
  database = client.get_database(DATABASE)
  collection = database.get_collection(COLLECTION)
  collection.update_one({}, {"$set": {"last_update": objectID}}, upsert=True)


def disconnect(client: pymongo.MongoClient):
    client.close()
