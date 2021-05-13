import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import os

PROJECT_ID = os.getenv("GCP_PROJECT_ID")
HEALTH_COLLECTION = os.getenv('FIRESTORE_HEALTH_COLLECTION')


global firebase_app, client
firebase_app = None
client = None


def save_all(status_list: list[dict]):
    try:
        execute(status_list)
    finally:
        _disconnect()
    

def execute(status_list: list[dict]):
    _init_client()
    for status in status_list:
        check_conformity(status)
        save_one(status)


def _init_client() -> firestore.client:
    global client, firebase_app
    
    if firebase_app is None:
        _create_firebase_app()
    if client is not None:
        return client

    client = firestore.client(firebase_app)


def _create_firebase_app():
    global firebase_app
    cred = credentials.ApplicationDefault()
    firebase_app = firebase_admin.initialize_app(cred, {
        'projectId': PROJECT_ID,
    })


def _disconnect():
    global client, firebase_app
    client = None
    if firebase_app is not None:
        firebase_admin.delete_app(firebase_app)
    firebase_app = None


def check_conformity(status: dict):
    environments = ['dev', 'test', 'prod']
    if 'ref' not in status:
        raise Exception(f'Ref is not defined for status: {str(status)}')
    if 'environment' not in status:
        raise Exception(f'Environment is not defined in status: {str(status)}')
    
    if not any(env in status['ref'] for env in environments):
        raise Exception(f'Ref don\'t have environment in it ')



def save_one(status: dict):
    global client
    doc_name = status['ref']
    doc_ref = client.collection(HEALTH_COLLECTION).document(doc_name)
    doc_ref.set(status)
