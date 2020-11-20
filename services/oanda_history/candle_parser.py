from typing import List, Dict


def flatten_all(latest_candles: List) -> List[Dict]:
    #type: list(dict)
    flattened_candles: List[Dict] = list()
    for candle in latest_candles:
        parsed_candle = flatten_single(candle)
        flattened_candles.extend(parsed_candle)
    
    return flattened_candles


def flatten_single(candle: Dict) -> List:
    flattened_candle: List[Dict] = list()
    instrument = candle['instrument']
    granularity = candle['granularity']
    
    for _candle in candle['candles']:
        temp_flat = dict()
        temp_flat["instrument"] = instrument
        temp_flat["granularity"] = granularity
        temp_flat['volume'] = _candle['volume']
        temp_flat["time"] = _candle['time']
        temp_flat['bid'] = _candle['bid']
        temp_flat['ask'] = _candle['ask']
        temp_flat['complete'] = _candle['complete']

        flattened_candle.append(temp_flat)
    
    return flattened_candle


def remove_incomplete_candle(flat_candle: List[Dict]) -> List:
    complete_candles: List[Dict] = list()
    for candle in flat_candle:
        if candle['complete'] == False:
            continue
        del candle['complete']
        complete_candles.append(candle)
    
    return complete_candles
