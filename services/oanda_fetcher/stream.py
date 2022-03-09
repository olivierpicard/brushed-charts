from http.client import HTTPException
import os
from typing import Callable
from unittest import mock
from urllib.error import HTTPError
import requests


def listen(url: str, callback: Callable):
    resp = __grab_response__(url)
    print("1")
    __raise_on_reponse_error__(resp)
    print("2")
    __dispatch_each_line__(resp, callback)
    print("3")


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
    print(response.text())
    for line in response.iter_lines():
        if line is None:
            continue
        callback(line)


def __raise_on_reponse_error__(resp: requests.Response):
    print("1.1")
    resp.raise_for_status()
    print("1.2")
    if(not resp.ok):
        print("1.2.1")
        raise HTTPException(f'Got a not OK resp. Body: {resp.text}')
        print("1.2.2")
    print("1.3")


def __raise_on_empty_token__(token: str):
    if(token is None or token == ''):
        raise ValueError("Token OANDA_API_KEY is not defined")
