from flask import Flask
from google.cloud import secretmanager
from google.cloud import error_reporting as greport
import os 
import firestore
import mail
import validity
import traceback

SECRET_PATH = os.getenv('SECRET_PATH_MAILGUN_API_KEY')
ENVIRONMENT = os.getenv('BRUSHED_CHARTS_ENVIRONMENT')

app = Flask(__name__)


def get_api_key():
    client = secretmanager.SecretManagerServiceClient()
    response = client.access_secret_version(request={"name": SECRET_PATH}, )
    payload = response.payload.data.decode("UTF-8")
    
    return payload


def prune_dev(documents: list[dict]):
    pruned_dev = list(filter(
            lambda doc: doc['environment'] != 'dev',
            documents))
    
    return pruned_dev


def process_diagnotics(documents: list[dict], api_key: str):
    for doc in documents:
        if validity.is_correct(doc):
            continue
        mail.send(doc, api_key)


def try_execute():
    try:
        api_key = get_api_key()
        diagnostics = firestore.get_documents()
        diagnostics = prune_dev(diagnostics)
        process_diagnotics(diagnostics, api_key)
    except:
        traceback.print_exc()
        if(ENVIRONMENT == 'dev'): return
        client = greport.Client(service=f'health_check.{ENVIRONMENT}')
        client.report_exception()


@app.route("/")
def check():
    try_execute()

    return "<html></html>"
