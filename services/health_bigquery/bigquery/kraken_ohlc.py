from google.cloud import bigquery as gbigquery
from bigquery import datetime_process
from datetime import datetime
import os

KRAKEN_BQ_PATH = os.getenv("KRAKEN_BIGQUERY_PATH_OHLC_TABLE")
ENVIRONMENT = os.getenv('BRUSHED_CHARTS_ENVIRONMENT')


def get_last_update_status(client: gbigquery.Client):
    check_environment_variable()
    query = make_oanda_prices_query()
    results = client.query(query).result()
    last_datetime = datetime_process.extract_datetime(results)
    is_valid = datetime_process.is_update_time_valid(last_datetime)
    status = make_status(last_datetime, is_valid)

    return status


def check_environment_variable():
    if KRAKEN_BQ_PATH is None or KRAKEN_BQ_PATH == '':
        raise Exception("KRAKEN_BQ_PATH is unset")
        

def make_oanda_prices_query():
    iso_str_min_bound = datetime_process.iso_min_bound_datetime()
    return f'''
    SELECT max(datetime)
    FROM {KRAKEN_BQ_PATH}
    WHERE datetime >= "{iso_str_min_bound}"
    '''


def make_status(update_datetime: datetime, validity: str):
    status = dict()
    status['title'] = f'{ENVIRONMENT}_bq_kraken_ohlc_last_inserted_datetime'
    status['description'] = 'Biquery Kraken OHLC - last inserted datetime'
    status['last_row'] = update_datetime
    status['updated_at'] = datetime.utcnow()
    status['validity'] = validity
    status['environment'] = ENVIRONMENT

    return status
