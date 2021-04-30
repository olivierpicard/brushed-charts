import os

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
    column['time'] = int(float(data_array[2]))
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
