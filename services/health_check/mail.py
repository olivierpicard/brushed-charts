import requests
import os

SENDER_EMAIL = 'error-report@mail.brushed-charts.com'
EMAIL_RECEIVER = os.getenv('ADMIN_EMAIL_ADDRESS')


def send(document: dict, api_key: str):
    params = _build_params(document)
    mail_vars = _mail_variables(params)
    print(_send(mail_vars, api_key).text)



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
    params = dict()
    params['title'] = raw_data['title']
    params['subtitle'] = raw_data['subtitle']
    params['description'] = raw_data['description']
    params['link'] = 'http://www.google.fr'
    params['details'] = str(raw_data).replace('\'', '')

    return params


def _send(variables: dict, api_key: str):
    print(api_key)
    print(variables)
    return requests.post(
        "https://api.eu.mailgun.net/v3/mail.brushed-charts.com/messages",
        auth=("api", api_key),
        data=variables
    )
