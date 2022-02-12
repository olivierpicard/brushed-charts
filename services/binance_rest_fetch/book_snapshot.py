from datetime import datetime
from time import sleep
import traceback
from binance.spot import Spot
from binance.error import ClientError as BinanceError
import config 
import cloud_logger

DEPTH_LIMIT = 5000
REQUEST_ID_SUFFIXE = '@snapshot_depth@5000'
SECONDS_BETWEEN_PAIR = 15


class BookSnapshot:
    client = None
    msg_callback = None


    def __init__(self,callback):
        self.client = Spot()
        self.msg_callback = callback


    def get_all_depths(self):
        for pair in config.pairs:
            try:
                depth = self.__get_enriched_depth__(pair)
                self.msg_callback(depth)
            except BinanceError as err:
                self.handle_binance_error(err)
                continue
            except Exception:
                log_body = {'message': traceback.format_exc()}
                cloud_logger.write_log(log_body, severity='ERROR')

            sleep(SECONDS_BETWEEN_PAIR)


    def __get_enriched_depth__(self, pair):
        depth = self.client.depth(pair.upper(), limit=DEPTH_LIMIT)
        depth['localtimestamp'] = datetime.now().timestamp()
        depth['request_name'] = f'{pair.upper()}{REQUEST_ID_SUFFIXE}'
        return depth


    def handle_binance_error(err: BinanceError):
        log_body = {'message': str(err), 'status_code': err.status_code}
        cloud_logger.write_log(log_body, severity='WARNING')
        if(err.status_code != 400): raise err

   
