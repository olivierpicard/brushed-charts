import time
import os
import bigquery_reader
import lastupdate
import presence_database
import traceback
import clean
import alert
from datetime import datetime, timedelta
from google.cloud import error_reporting

REFRESH_RATE = os.getenv("PRESENCE_REFRESH_RATE_SECONDS")  # In seconds
ENVIRONMENT = os.getenv("BRUSHED_CHARTS_ENVIRONMENT")


class EmptyResultException(Exception):
    pass


def raise_for_empty_result(result: list):
    if result is None or len(result) == 0:
        raise EmptyResultException


def make_date_window():
    last_update_date = lastupdate.read()
    current_datetime = datetime.utcnow()
    upper_bound_date = current_datetime - timedelta(minutes=3)

    return (last_update_date, upper_bound_date)


def execute():
    date_window = make_date_window()
    presences = bigquery_reader.get_presence_from_date_window(date_window)
    alert.email_on_no_presence(presences)
    raise_for_empty_result(presences)
    presence_database.insert_all(presences)
    upper_bound_date = date_window[1]
    lastupdate.save(upper_bound_date)
    clean.delete_old()


def try_to_execute():
    try:
        execute()
    except EmptyResultException:
        pass
    except Exception:
        traceback.print_exc()
        error_reporting.Client(
            service="presence_bigquery."+ENVIRONMENT).report_exception()


if __name__ == "__main__":
    while True:
        try_to_execute()
        time.sleep(int(REFRESH_RATE))
