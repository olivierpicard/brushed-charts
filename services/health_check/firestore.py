import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

PROJECT_ID = "brushed-charts"
HEALTH_COLLECTION = "health"

global firebase_app, client
firebase_app = None
client = None


def get_documents():
    docs = None
    try:
        _init_client()
        docs = _read()
    finally:
        _disconnect()
    
    return docs


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


def _read() -> list:
    global client
    query_stream = client.collection(HEALTH_COLLECTION).stream()
    docs = list(map(lambda doc: doc.to_dict(), query_stream))
    
    return docs
