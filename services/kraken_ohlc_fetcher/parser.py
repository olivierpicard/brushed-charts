import os
from datetime import datetime


GRANULARITY = os.getenv("KRAKEN_OHLC_GRANULARITY")


def give_column_name(message: str) -> dict:
    message = keep_value_only(message)
    values_array = ohlc_to_array(message)
    named_column = attribute_name(values_array)

    return named_column


def keep_value_only(message: str) -> str:
    message = message.replace('[', '')
    message = message.replace(']', '')
    message = message.replace('"', '')
    clean_data = message

    return clean_data


def ohlc_to_array(message: str) -> list:
    values = message.split(',')
    return values


def attribute_name(data_array: list) -> dict:
    column = {}
    column['datetime'] = timestamp_to_iso_datetime(data_array[2])
    column['asset_pair'] = data_array[11]
    column['granularity'] = GRANULARITY
    column['open'] = float(data_array[3])
    column['high'] = float(data_array[4])
    column['low'] = float(data_array[5])
    column['close'] = float(data_array[6])
    column['vwap'] = float(data_array[7])
    column['volume'] = float(data_array[8])
    column['trade_count'] = int(data_array[9])

    return column


def timestamp_to_iso_datetime(str_timestamp: str) -> str:
    timestamp = int(float(str_timestamp))
    utc_datetime = datetime.utcfromtimestamp(timestamp)
    iso_datetime = utc_datetime.isoformat()

    return iso_datetime
