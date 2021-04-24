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
        temp_flat['mid'] = _candle['mid']
        temp_flat['ask'] = _candle['ask']
        temp_flat['complete'] = _candle['complete']
        parse_OHLC(temp_flat['bid'])
        parse_OHLC(temp_flat['mid'])
        parse_OHLC(temp_flat['ask'])
        flattened_candle.append(temp_flat)
    
    return flattened_candle


def parse_OHLC(ohlc: Dict):
    ohlc['open'] = ohlc['o']
    del ohlc['o']
    ohlc['high'] = ohlc['h']
    del ohlc['h']
    ohlc['low'] = ohlc['l']
    del ohlc['l']
    ohlc['close'] = ohlc['c']
    del ohlc['c']


def remove_incomplete_candle(flat_candle: List[Dict]) -> List:
    complete_candles: List[Dict] = list()
    for candle in flat_candle:
        if candle['complete'] == False:
            continue
        del candle['complete']
        complete_candles.append(candle)
    
    return complete_candles


def change_fieldname_time_with_date(flat_candles: List[Dict]) -> List:
    for candle in flat_candles:
        candle["date"] = candle["time"]
        candle["date"] = candle["date"].split(".")[0] + "Z"
        del candle["time"]
