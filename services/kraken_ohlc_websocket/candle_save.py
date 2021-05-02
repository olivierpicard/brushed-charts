import pymongo
import os

HOST = os.getenv("MONGODB_HOST")
PORT = os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_KRAKEN_DBNAME")
COLLECTION = os.getenv("MONGODB_KRAKEN_OHLC_COLLECTION")


def save(candle: dict):
    client = connect_to_database()
    collection = get_collection(client)
    create_index(collection)
    upsert(candle, collection)
    disconnect(client)


def connect_to_database() -> pymongo.database.Database:
    client = pymongo.MongoClient(host=HOST, port=int(PORT))

    return client


def create_index(collection: pymongo.collection.Collection):
    collection.create_index(
        [("datetime", -1), ("asset_pair", 1), ("granularity", 1)],
        unique=True)


def get_collection(client: pymongo.MongoClient) -> pymongo.collection.Collection:
    database = client.get_database(name=DATABASE)
    collection = database.get_collection(name=COLLECTION)

    return collection


def upsert(candle: dict, collection: pymongo.collection.Collection):
    collection.update_one(
        {
            "datetime": candle['datetime'],
            "asset_pair": candle['asset_pair'],
            "granularity": candle['granularity']
        },
        {"$set": candle},
        upsert=True
    )


def disconnect(client: pymongo.MongoClient):
    client.close()
