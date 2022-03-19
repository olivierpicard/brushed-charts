import json
import os
from typing import Callable
import requests


def listen(url: str, callback: Callable):
    resp = __grab_response__(url)
    resp.raise_for_status()
    __dispatch_each_line__(resp, callback)


def __grab_response__(url: str) -> requests.Response:
    header = __make_header__()
    session = requests.Session()
    resp = session.get(url, headers=header, stream=True)
    return resp


def __make_header__() -> dict:
    token = os.environ['OANDA_API_TOKEN']
    return {
        "authorization": f'Bearer {token}',
        "Accept-Datetime-Format": "RFC3339"
    }


def __dispatch_each_line__(response: requests.Response, callback: Callable):
    for line in response.iter_lines(decode_unicode=True):
        json_line = json.loads(line)
        if(json_line['type'] != 'PRICE'):
            continue
        callback(json_line)
