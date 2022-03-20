import json


def __load__(path: str):
    file = open(path)
    data = json.load(file)
    file.close()
    return data


def load_pairs(path: str) -> list:
    raw_data = __load__(path)
    return raw_data['pairs']
