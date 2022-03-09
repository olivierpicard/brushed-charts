from http.client import HTTPException
import os
from typing import Callable
from unittest import mock
from urllib.error import HTTPError
import requests


def listen(url: str, callback: Callable):
    resp = __grab_response__(url)
    __raise_on_reponse_error__(resp)
    __dispatch_each_line__(resp, callback)


def __grab_response__(url: str) -> requests.Response:
    header = __make_header__()
    session = requests.Session()
    resp = session.get(url, headers=header, stream=True)
    return resp


def __make_header__() -> dict:
    token = os.getenv('OANDA_API_TOKEN')
    __raise_on_empty_token__(token)
    return {
        "Authorisation": token,
        "Accept-Datetime-Format": "RFC3339"
    }


def __dispatch_each_line__(response: requests.Response, callback: Callable):
    for line in response.iter_lines():
        if line is None:
            continue
        callback(line)


def __raise_on_reponse_error__(resp: requests.Response):
    resp.raise_for_status()
    if(not resp.ok):
        raise HTTPException(f'Got a not OK resp. Body: {resp.text}')


def __raise_on_empty_token__(token: str):
    if(token is None or token == ''):
        raise ValueError("Token OANDA_API_KEY is not defined")