import json
from datetime import datetime

LINE_TO_SELECT = 50


class PriceResponse(object):
    def __init__(self, raw_response: str, pair: str, granularity: int):
        self.raw_json_response = json.loads(raw_response)
        self.pair = pair
        self.granularity = granularity
        self.data = self.parse()
        self.data = self.select_pertinente_lines()


    def select_pertinente_lines(self):
        return self.data[-LINE_TO_SELECT:-1]


    def parse(self):
        self.raise_for_error()
        raw_result = self.extract_result()
        parsed_result = list(map(self.give_column_a_name, raw_result))

        return parsed_result

        

    def raise_for_error(self):
        error = self.raw_json_response['error']
        if not isinstance(error, list):
            t = type(error)
            raise Exception(f"error type is {t} expected a list")
        if len(error) > 0:
            raise Exception(str(error))


    def extract_result(self):
        result = self.raw_json_response['result']
        asset_pair = list(result.keys())[0]
        extracted_data = result[asset_pair]

        return extracted_data


    def give_column_a_name(self, result_line):
        named_result = dict()
        timestamps = int(result_line[0])
        iso_datetime = datetime.utcfromtimestamp(timestamps).isoformat()
        named_result['datetime'] = iso_datetime
        named_result['asset_pair'] = self.pair
        named_result['granularity'] = self.granularity
        named_result['open'] = float(result_line[1])
        named_result['high'] = float(result_line[2])
        named_result['low'] = float(result_line[3])
        named_result['close'] = float(result_line[4])
        named_result['vwap'] = float(result_line[5])
        named_result['volume'] = float(result_line[6])
        named_result['trade_count'] = int(result_line[7])

        return named_result
