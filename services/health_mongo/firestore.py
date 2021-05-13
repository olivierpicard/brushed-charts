import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import os

PROJECT_ID = os.getenv("GCP_PROJECT_ID")
HEALTH_COLLECTION = os.getenv('FIRESTORE_HEALTH_COLLECTION')

global firebase_app
firebase_app = None


def save_all(status_list: list[dict]):
    db = get_client()
    for status in status_list:
        check_conformity(status)
        save_one(db, status)
    disconnect()


def get_client() -> firestore.client:
    create_firebase_app()
    if firebase_app is None:
        create_firebase_app()

    return firestore.client(firebase_app)


def create_firebase_app():
    global firebase_app
    cred = credentials.ApplicationDefault()
    firebase_app = firebase_admin.initialize_app(cred, {
        'projectId': PROJECT_ID,
    })


def disconnect():
    firebase_admin.delete_app(firebase_app)


def check_conformity(status: dict):
    environments = ['dev', 'test', 'prod']
    if 'ref' not in status:
        raise Exception(f'Ref is not defined for status: {str(status)}')
    if 'environment' not in status:
        raise Exception(f'Environment is not defined in status: {str(status)}')
    
    if not any(env in status['ref'] for env in environments):
        raise Exception(f'Ref don\'t have environment in it')



def save_one(db: firestore.client, status: dict):
    doc_name = status['ref']
    doc_ref = db.collection(HEALTH_COLLECTION).document(doc_name)
    doc_ref.set(status)
