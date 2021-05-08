import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import os

PROJECT_ID = os.getenv("GCP_PROJECT_ID")
HEALTH_COLLECTION = os.getenv('FIRESTORE_HEALTH_COLLECTION')


def save_all(status_list: list[dict]):
    db = get_client()
    for status in status_list:
        check_conformity(status)
        save_one(db, status)


def get_client() -> firestore.client:
    cred = credentials.ApplicationDefault()
    firebase_admin.initialize_app(cred, {
        'projectId': PROJECT_ID,
    })

    return firestore.client()


def check_conformity(status: dict):
    environments = ['dev', 'test', 'prod']
    if 'title' not in status:
        raise Exception(f'Title is not defined for status: {str(status)}')
    if 'environment' not in status:
        raise Exception(f'Environment is not defined in status: {str(status)}')
    
    if not any(env in status['title'] for env in environments):
        raise Exception(f'Title don\'t have environment in it ')



def save_one(db: firestore.client, status: dict):
    doc_name = status['title']
    doc_ref = db.collection(HEALTH_COLLECTION).document(doc_name)
    doc_ref.set(status)
