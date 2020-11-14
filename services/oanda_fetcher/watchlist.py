from typing import List
import pymongo
import os

HOST = os.getenv("MONGODB_HOST")
PORT = os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_OANDA_DBNAME")
WATCHLIST_COLLECTION = os.getenv("MONGODB_OANDA_WATCHLIST_COLLECTION")


def get_instruments():
    client = connect()
    collection = get_collection(client=client)
    instrumensts = get_all(collection)
    disconnect(client)

    return instrumensts


def connect() -> pymongo.MongoClient:
    client = pymongo.MongoClient(host=HOST, port=int(PORT))

    return client


def get_collection(client: pymongo.MongoClient) -> pymongo.collection.Collection:
    database = client.get_database(name=DATABASE)
    collection = database.get_collection(name=WATCHLIST_COLLECTION)

    return collection


def get_all(collection: pymongo.collection.Collection) -> List[str]:
    instruments: List[str] = list()
    cursor = collection.find({})    
    for document in cursor:
        instruments.append(document['symbole'])
    
    return instruments


def disconnect(client: pymongo.MongoClient):
    client.close()


