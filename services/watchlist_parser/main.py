import re
import os

WATCHLIST_PATH = os.getenv('OANDA_WATCHLIST_PATH')

def get_instruments_from_watchlist(watchlist_path: str):
    content = read_watchlist(watchlist_path)
    instruments = parse_watchlist_content(content)
    return instruments

def read_watchlist(watchlist_path: str) -> str :
    with open(WATCHLIST_PATH, mode='r') as f:
        return f.read()

def parse_watchlist_content(content: str) -> list:
    regex = r"^\w+"
    matches = re.findall(regex, content, re.MULTILINE)
    return matches

if __name__ == "__main__":
    print(get_instruments_from_watchlist(WATCHLIST_PATH))

