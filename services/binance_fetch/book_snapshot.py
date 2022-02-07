from datetime import datetime
from time import sleep
from binance.spot import Spot
from binance.error import ClientError as BinanceError
import config 

DEPTH_LIMIT = 5000
REQUEST_ID_SUFFIXE = '@snapshot_depth@5000'
SECONDS_BETWEEN_PAIR = 15
SECONDS_BETWEEN_FETCH = 30 * 60 * 60

class BookSnapshot:
    client = None
    msg_callback = None

    def __init__(self,depth_callback):
        self.client = Spot()
        self.msg_callback = depth_callback

    def __get_all_depths__(self):
        for pair in config.pairs:
            try:
                depth = self.__get_enriched_depth__(pair)
                self.msg_callback(depth)
            except BinanceError as err:
                err.status_code == 400
                continue
            except Exception as err:
                print(err)
        sleep(SECONDS_BETWEEN_PAIR)

    def __get_enriched_depth__(self, pair):
        depth = self.client.depth(pair.upper(), limit=DEPTH_LIMIT)
        depth['localtimestamp'] = datetime.now().timestamp()
        depth['request_name'] = f'{pair.upper}{REQUEST_ID_SUFFIXE}'
        return depth

    def start(self):
        while True:
            self.__get_all_depth__()
            sleep(SECONDS_BETWEEN_FETCH)
