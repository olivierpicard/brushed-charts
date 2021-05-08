from google.cloud import error_reporting as greport
from kraken_ohlc import kraken_ohlc
from oanda_prices import oanda_prices
import os
import time
import traceback
import firestore

ENVIRONMENT = os.getenv('BRUSHED_CHARTS_ENVIRONMENT')
REFRESH_RATE = 10 * 60  # 10 minutes in seconds


def build_status() -> list[dict]:
    status_list = list()
    status_list.append(kraken_ohlc.get_status())
    status_list.append(oanda_prices.get_status())

    return status_list


def try_execute():
    try:
        status_list = build_status()
        firestore.save_all(status_list)
    except:
        traceback.print_exc()
        if(ENVIRONMENT == 'dev'): return
        client = greport.Client(service=f'health_mongo.{ENVIRONMENT}')
        client.report_exception()


def check_environment_variable():
    if ENVIRONMENT is None:
        raise Exception("ENVIRONMENT is unset")


if __name__ == '__main__':
    while True:
        check_environment_variable()
        try_execute()
        time.sleep(REFRESH_RATE)
