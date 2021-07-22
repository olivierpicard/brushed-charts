import pymongo
import os
from datetime import datetime, timedelta
from bson.objectid import ObjectId

COLLECTION = os.getenv("MONGODB_KRAKEN_OHLC_BIGQUERY_LAST_SAVE_COLLECTION")
HISTORY_COLLECTION = os.getenv("MONGODB_KRAKEN_OHLC_COLLECTION")
HOURS_EARLIER = datetime.utcnow() - timedelta(hours=12)


class EmptyReferenceObject(Exception):
  pass


def get(database):
  collection = database.get_collection(COLLECTION)
  document = collection.find_one()
  if document is None or type(document['last_update']) is datetime:
    init(database)
    document = collection.find_one()

  return document


def init(database):
  cursor = get_initial_object_cursor(database)
  initial_object = cursor_to_initial_object(cursor)
  put_initial_object(database, initial_object)



def get_initial_object_cursor(database) -> ObjectId:
  history_collection = database.get_collection(HISTORY_COLLECTION)
  refobj = ObjectId.from_datetime(HOURS_EARLIER)
  cursor = history_collection\
    .find({"_id": {"$gte": refobj}})\
    .sort("_id", pymongo.ASCENDING).limit(1)

  return cursor


def cursor_to_initial_object(cursor):
  if cursor.count == 0:
    raise EmptyReferenceObject()
  initial_object = cursor[0]['_id']

  return initial_object


def put_initial_object(database, objectId: ObjectId):
  collection = database.get_collection(COLLECTION)
  collection.update_one({}, {'$set': {'last_update': objectId}}, upsert=True)
  

def get_greatest_item(candles: list):
  object_list = map(lambda x: x['_id'], candles)
  greater_object = max(object_list)

  return greater_object
