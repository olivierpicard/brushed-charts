from typing import Dict, List
import requests
import json


class Fetcher(object):
    session: requests.Session
    token: str
    url_path: str
    granularities: List[str]


    def __init__(self, token: str, url_path: str, granularities: List[str]):
        self.token = token
        self.url_path = url_path
        self.granularities = granularities
        self.session = requests.Session()


    def get_latest_candles(self, instruments: List[str]) -> List:
        json_response = self.fetch(instruments)
        latest_candles = json_response["latestCandles"]
        
        return latest_candles


    def fetch(self, instruments: List[str]) -> Dict:
        headers = self.make_header()
        url = self.build_url_with_parameters(instruments)
        response = self.session.get(url=url, headers=headers)
        response.raise_for_status()
        json_response = response.json()
        
        return json_response
        

    def make_header(self) -> Dict[str, str]:
        header = {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + self.token
        }

        return header


    def build_url_with_parameters(self, instruments: List[str]) -> str :
        parameter_list = self.make_parameter_list(instruments)
        assembled_parameters_str = self.concat_parameters(parameter_list)
        full_url = self.url_path + "?candleSpecifications=" + assembled_parameters_str
        return full_url


    def make_parameter_list(self, instruments: List[str]) -> List[str]:
        parameters_list: List[str] = list()
        for granularity in self.granularities:
            for instrument in instruments:
                parameter = self.assemble_options(granularity, instrument)
                parameters_list.append(parameter)

        return parameters_list


    def assemble_options(self, granularity: str, instrument: str) -> str:
        return instrument + ":" + granularity + ":BA"


    def concat_parameters(self, parameters: List[str]):
        return ','.join(parameters)