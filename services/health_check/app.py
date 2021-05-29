from flask import Flask
from google.cloud import error_reporting as greport
import os
import traceback
import firestore
import mail
import mail_interval
import validity

MAILGUN_API_KEY = os.getenv('MAILGUN_API_KEY')
VERSION = "1.0"


app = Flask(__name__)


def prune_dev(documents: list[dict]):
    pruned_dev = list(filter(
            lambda doc: doc['environment'] != 'dev',
            documents))
    
    return pruned_dev


def process_diagnotics(documents: list[dict], api_key: str):
    for doc in documents:
        ref = doc['ref']
        emails = mail_interval.get_email_send_datetime()
        if validity.is_correct(doc):
            continue
        if not validity.is_ready_for_email(ref, emails):
            continue
        mail.send(doc, api_key)
        mail_interval.update(ref)


def try_execute():
    try:
        diagnostics = firestore.get_documents()
        diagnostics = prune_dev(diagnostics)
        process_diagnotics(diagnostics, MAILGUN_API_KEY)
    except:
        traceback.print_exc()
        client = greport.Client(service=f'health_check')
        client.report_exception()


@app.route("/")
def check():
    try_execute()
    return f"<html>VERSION: {VERSION}</html>"
