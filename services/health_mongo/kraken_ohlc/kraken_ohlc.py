from datetime import datetime
from kraken_ohlc import kraken_ohlc_mongo
import os

ACCEPTABLE_DELAY = 5 * 60  # x minutes in seconds
ENVIRONMENT = os.getenv('BRUSHED_CHARTS_ENVIRONMENT')
REFRESH_RATE = int(os.getenv('HEALTH_MONGO_REFRESH_RATE'))  # in seconds


def get_status():
    last_datetime = kraken_ohlc_mongo.read_last_datetime()
    validity = _is_valid(last_datetime)
    status = _make_status(last_datetime, validity)

    return status


def _is_valid(last_datetime: datetime):
    if last_datetime is None:
        return False
    if not _is_delay_acceptable(last_datetime):
        return False

    return True


def _is_delay_acceptable(last_datetime: datetime):
    diff = datetime.utcnow() - last_datetime
    if diff.total_seconds() > ACCEPTABLE_DELAY:
        return False
    
    return True


def _make_status(last_datetime: datetime, validity: str):
    status = dict()
    status['ref'] = f'{ENVIRONMENT}_mongo_kraken_ohlc_last_inserted_datetime'
    status['title'] = 'Mongo Kraken OHLC'
    status['subtitle'] = 'Last inserted datetime'
    status['last_row'] = last_datetime
    status['updated_at'] = datetime.utcnow()
    status['validity'] = validity
    status['environment'] = ENVIRONMENT
    status['refresh_rate'] = REFRESH_RATE

    return status
