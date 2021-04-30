import re


def is_error(message: str) -> bool:
    if is_status_error(message):
        return True
    if is_error_event(message):
        return True


def is_status_error(message: str) -> bool:
    if 'status:' in message and 'status:online' not in message:
        return True
    return False


def is_error_event(message: str) -> bool:
    if '"event": "error"' in message:
        return True
    return False


def is_ohlc(message: str) -> bool:
    regex = r"\[\d+,\[.*\],\"ohlc-\d+\",\"[A-Z]{3}/[A-Z]{3}\"\]"
    if re.match(regex, message):
        return True

    return False
