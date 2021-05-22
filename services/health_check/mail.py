from datetime import datetime
import requests
import os

SENDER_EMAIL = 'error-report@mail.brushed-charts.com'
EMAIL_RECEIVER = os.getenv('ADMIN_EMAIL_ADDRESS')


def send(document: dict, api_key: str):
    params = _build_params(document)
    mail_vars = _mail_variables(params)
    _send(mail_vars, api_key)


def _mail_variables(params: dict):
    variables = str(params).replace('\'', '"')
    return {
        "from": f"Brushed-Charts Report <{SENDER_EMAIL}>",
        "to": f"{EMAIL_RECEIVER}",
        "subject": f"error in {params['title']}",
        "template": "error-report",
        "h:X-Mailgun-Variables": variables
    }


def _build_params(document):
    raw_data = dict.copy(document)
    details = dict.copy(document)
    details = _build_details(details)
    params = dict()
    params['title'] = raw_data['title']
    params['subtitle'] = raw_data['subtitle']
    params['description'] = raw_data['description']
    params['link'] = 'http://www.google.fr'
    params['details'] = details

    return params


def _build_details(document: dict):
    _format_date(document)
    _remove_useless_fields(document)
    details = _prettify(document)

    return details


def _format_date(document: dict):
    for key, value in document.items():
        if isinstance(value, datetime):
            document[key] = value.isoformat()


def _remove_useless_fields(document: dict):
    del document['title']
    del document['subtitle']
    del document['description']


def _prettify(document: dict):
    pretty_doc = str(document).replace('\'', '')
    pretty_doc = pretty_doc.replace(',', ',<br/>')
    
    return pretty_doc


def _send(variables: dict, api_key: str):
    return requests.post(
        "https://api.eu.mailgun.net/v3/mail.brushed-charts.com/messages",
        auth=("api", api_key),
        data=variables
    )
