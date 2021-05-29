from google.cloud import bigquery as gbigquery
from datetime import datetime, timedelta, timezone

MIN_BOUND = 3  # days
ACCEPTABLE_DELAY = 10  # minutes


def iso_min_bound_datetime():
    utc_dt = datetime.utcnow() - timedelta(days=MIN_BOUND)
    iso_datetime = utc_dt.isoformat()

    return iso_datetime


def extract_datetime(results: gbigquery.table.RowIterator) -> datetime:
    last_update = None
    for row in results:
        last_update = row[0]

    return last_update


def minutes_difference_with_now(last_update: datetime) -> int:
    diff_with_now = datetime.now(timezone.utc) - last_update
    diff_seconds = diff_with_now.total_seconds()
    diff_minutes = diff_seconds / 60

    return diff_minutes


def is_update_time_valid(last_row_strdatetime: str):
    if last_row_strdatetime is None:
        return False

    minutes_difference = minutes_difference_with_now(last_row_strdatetime)
    if minutes_difference > ACCEPTABLE_DELAY:
        return False
    
    return True
