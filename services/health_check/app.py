from flask import Flask
from firebase_admin import firestore
import re

app = Flask(__name__)


@app.route("/")
def check():
    docs = db.collection(u'cities').stream()
    for doc in docs:
        print(f'{doc.id} => {doc.to_dict()}')
