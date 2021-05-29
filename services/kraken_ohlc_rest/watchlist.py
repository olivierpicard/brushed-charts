import os

WATCHLIST_PATH = os.getenv("KRAKEN_WATCHLIST_PATH")


def get_asset_pairs() -> list[str]:
    pairs = None
    with open(WATCHLIST_PATH) as file:
        pairs = file.readlines()
    check_watchlist(pairs)
    pairs = remove_blank_lines(pairs)
    pairs = remove_new_lines(pairs)
    pairs = remove_quotes(pairs)

    return pairs


def check_watchlist(pairs: list[str]):
    if pairs is None:
        raise Exception("Kraken watchlist is empty")


def remove_blank_lines(pairs: list[str]):
    return list(filter(lambda x: x != '\n', pairs))


def remove_new_lines(pairs):
    return list(map(lambda x: x.replace('\n', ''), pairs))


def remove_quotes(pairs):
    return list(map(lambda x: x.replace('"', ''), pairs))
