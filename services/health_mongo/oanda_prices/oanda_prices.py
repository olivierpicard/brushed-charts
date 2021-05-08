from datetime import datetime
from oanda_prices import oanda_prices_mongo
import os

ACCEPTABLE_DELAY = 5 * 60  # x minutes in seconds
ENVIRONMENT = os.getenv('BRUSHED_CHARTS_ENVIRONMENT')


def get_status():
    last_datetime = oanda_prices_mongo.read_last_datetime()
    validity = _is_valid(last_datetime)
    status = _make_status(last_datetime, validity)

    return status


def _is_valid(last_datetime: datetime):
    if last_datetime is None:
        return False
    if _its_weekend(last_datetime):
        return True
    if not _is_delay_acceptable(last_datetime):
        return False

    return True


def _is_delay_acceptable(last_datetime: datetime):
    diff = datetime.utcnow() - last_datetime
    if diff.total_seconds() > ACCEPTABLE_DELAY:
        return False
    
    return True


def _its_weekend(dt: datetime) -> bool:
    diff_time = datetime.utcnow() - dt
    if diff_time.days >= 3:
        return False
    
    if dt.weekday() == 4 and dt.hour == 20:
        return True

    return False


def _make_status(last_datetime: datetime, validity: str):
    status = dict()
    status['title'] = f'{ENVIRONMENT}_mongo_oanda_history_last_inserted_datetime'
    status['description'] = 'Mongo Oanda history - last inserted datetime'
    status['last_row'] = last_datetime
    status['updated_at'] = datetime.utcnow()
    status['validity'] = validity
    status['environment'] = ENVIRONMENT

    return status
