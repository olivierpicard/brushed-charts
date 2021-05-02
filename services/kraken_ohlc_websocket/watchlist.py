import os

WATCHLIST_PATH = os.getenv("KRAKEN_WATCHLIST_PATH")


def get_asset_pairs() -> list[str]:
    pairs = None
    with open(WATCHLIST_PATH) as file:
        pairs = file.readlines()
    check_watchlist(pairs)
    pairs = remove_blank_lines(pairs)
    return pairs


def check_watchlist(pairs: list[str]):
    if pairs is None:
        raise Exception("Kraken watchlist is empty")


def remove_blank_lines(pairs: list[str]):
    return list(filter(lambda x: x != '\n', pairs))
