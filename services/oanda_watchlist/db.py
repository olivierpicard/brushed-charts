from typing import List
import pymongo
import os


class DatabaseUpdater:
    FIELD_NAME="symbole"
    host: str
    port: int
    dbname: str
    collection_name: str
    
    client: pymongo.MongoClient
    database: pymongo.database.Database
    
    def __init__(self, host: str, port: int, dbname: str, collection_name: str):
        self.host = host
        self.port = int(port)
        self.dbname = dbname
        self.collection_name = collection_name

    def update(self, instruments: List[str]):
        self.init()
        documents = self.transform_to_documents(instruments)
        collection = self.reset_collection(self.collection_name)
        collection.insert_many(documents)
        self.disconnect()
    
    def init(self):
        self.client = pymongo.MongoClient(host=self.host, port=self.port)
        self.database = self.client.get_database(self.dbname) #pylint: disable=W0612

    def transform_to_documents(self, instruments: List[str]):
        # a document should has {symbole: instrumentName} format
        return [{self.FIELD_NAME:instru} for instru in instruments]
        
    def reset_collection(self, collection_name: str) -> pymongo.collection.Collection:
        self.database.drop_collection(collection_name)
        collection = self.database.get_collection(collection_name)
        collection.create_index(self.FIELD_NAME, unique=True)
        return collection

    def disconnect(self):
        self.client.close()