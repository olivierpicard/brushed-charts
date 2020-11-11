import re

def get_instruments_from_watchlist(watchlist_path: str):
    content = read_watchlist(watchlist_path)
    instruments = parse_watchlist_content(content)
    return instruments

def read_watchlist(watchlist_path: str) -> str :
    with open(watchlist_path, mode='r') as f:
        return f.read()

def parse_watchlist_content(content: str) -> list:
    regex = r"^\w+"
    matches = re.findall(regex, content, re.MULTILINE)
    return matches