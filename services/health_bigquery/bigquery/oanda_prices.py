from google.cloud import bigquery as gbigquery
from bigquery import datetime_process
from datetime import datetime
import os

OANDA_BQ_PATH = os.getenv("OANDA_BIGQUERY_PATH_PRICE_TABLE")
ENVIRONMENT = os.getenv('BRUSHED_CHARTS_ENVIRONMENT')


def get_last_update_status(client: gbigquery.Client) -> dict[str]:
    check_environment_variable()
    query = make_oanda_prices_query()
    results = client.query(query).result()
    last_datetime = datetime_process.extract_datetime(results)
    validity = is_valid(last_datetime)
    status = make_status(last_datetime, validity)
    
    return status


def check_environment_variable():
    if OANDA_BQ_PATH is None or OANDA_BQ_PATH == '':
        raise Exception("OANDA_BIGQUERY_PATH_PRICE_TABLE is unset")
        

def make_oanda_prices_query() -> str:
    iso_str_min_bound = datetime_process.iso_min_bound_datetime()
    return f'''
    SELECT max(date),
    FROM {OANDA_BQ_PATH}
    WHERE date >= "{iso_str_min_bound}"
    '''


def is_valid(last_datetime: datetime) -> bool:
    if its_weekend():
        return True

    return datetime_process.is_update_time_valid(last_datetime)


def its_weekend() -> bool:
    dt = datetime.utcnow()
    if dt.weekday == 5 or dt.weekday == 6:
        return True
    if dt.weekday == 4 and dt.hour == 20:
        return True

    return False


def make_status(update_datetime: datetime, validity: str) -> dict[str]:
    status = dict()
    status['title'] = f'{ENVIRONMENT}_bq_oanda_prices_last_inserted_datetime'
    status['description'] = 'Biquery Oanda prices - last inserted datetime'
    status['last_row'] = update_datetime
    status['updated_at'] = datetime.utcnow()
    status['validity'] = validity
    status['environment'] = ENVIRONMENT

    return status
