from bson import ObjectId
import os
from typing import Tuple
import pymongo


HOST = os.getenv("MONGODB_HOST")
PORT = os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_OANDA_DBNAME")
COLLECTION = os.getenv("MONGODB_OANDA_HISTORY_COLLECTION")
MAX_DOCUMENT_LOADED = 200


def get_fresh_candles(window: Tuple[int, int]):
  client = connect()
  collection = get_history_collection(client)
  documents = list(select_documents_after(window, collection))
  disconnect(client)

  return documents


def connect() -> pymongo.MongoClient:
  client = pymongo.MongoClient(host=HOST, port=int(PORT))

  return client


def get_history_collection(client: pymongo.MongoClient):
  database = client.get_database(DATABASE)
  collection = database.get_collection(COLLECTION)
  
  return collection


def select_documents_after(refobj: ObjectId, collection: pymongo.collection.Collection) -> pymongo.cursor.Cursor:
  time_filter = {"_id": {"$gt": refobj}}
  cursor = collection.find(time_filter).sort('date').limit(MAX_DOCUMENT_LOADED)
  return cursor


def disconnect(client: pymongo.MongoClient):
  client.close()
