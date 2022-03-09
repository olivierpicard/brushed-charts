from typing import List

DOMAIN_NAME = 'https://stream-fxtrade.oanda.com'
GENERIC_PATH = 'v3/accounts/{accountID}/pricing/stream'

def build(account_id: str, pairs: List[str]) -> str:
    path = _make_path(account_id)
    options = _make_options(pairs)
    full_url = f'{DOMAIN_NAME}/{path}?{options}'
    return full_url
    

def _make_path(account_id: str) -> str:
    _raise_on_invalid_account_id(account_id)
    path = GENERIC_PATH.replace('{accountID}', account_id)
    return path


def _make_options(pairs: List[str]) -> str:
    _raise_on_invalid_pairs(pairs)
    instru_list = '%2'.join(pairs)
    option = f'instruments={instru_list}'
    return option


def _raise_on_invalid_account_id(account_id: str) -> None:
    if account_id == '':
        raise ValueError("account_id can't be an empty")
    if account_id is None:
        raise TypeError("account_id can't be None")


def _raise_on_invalid_pairs(pairs: List[str]) -> None:
    if len(pairs) > 0:
        return
    raise ValueError("Should at least have one asset_pairs in the list")
