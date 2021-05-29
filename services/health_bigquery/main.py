from google.cloud import error_reporting as greport
import os
import time
from bigquery import validator
import firestore
import traceback

ENVIRONMENT = os.getenv('BRUSHED_CHARTS_ENVIRONMENT')
REFRESH_RATE = int(os.getenv('HEALTH_BIGQUERY_REFRESH_RATE'))  # in seconds


def build_status() -> list[dict]:
    bq_tables_status = validator.get_status()

    return bq_tables_status


def try_execute():
    try:
        status_list = build_status()
        firestore.save_all(status_list)
    except:
        traceback.print_exc()
        if(ENVIRONMENT == 'dev'): return
        client = greport.Client(service=f'health_bigquery.{ENVIRONMENT}')
        client.report_exception()


def check_environment_variable():
    if ENVIRONMENT is None:
        raise Exception("ENVIRONMENT is unset")


if __name__ == '__main__':
    while True:
        check_environment_variable()
        try_execute()
        time.sleep(REFRESH_RATE)
