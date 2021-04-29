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
    r = re.compile(regex)
    if re.match(regex, message):
        return True
    return False


def give_column_name(message: str) -> dict:
    message = keep_value_only(message)
    values_array = ohlc_to_array(message)
    named_column = attribute_name(values_array)
    print(named_column)



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
    column['time'] = data_array[2]
    column['open'] = data_array[3]
    column['high'] = data_array[4]
    column['low'] = data_array[5]
    column['close'] = data_array[6]
    column['vwap'] = data_array[7]
    column['volume'] = data_array[8]
    column['trade_count'] = data_array[9]
    column['asset_pair'] = data_array[11]

    return column
