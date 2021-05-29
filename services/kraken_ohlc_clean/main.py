import time
import history
import os
import traceback
from google.cloud import error_reporting
from datetime import datetime, timedelta

REFRESH_RATE = 60 * 30  # In seconds
DELETE_FROM_DATE = int(os.getenv("KRAKEN_CLEAN_OHLC_FROM_N_DAYS"))
ENVIRONMENT = os.getenv("BRUSHED_CHARTS_ENVIRONMENT")


def deletion_limit() -> datetime:
    datetime_limit = datetime.utcnow() - timedelta(days=DELETE_FROM_DATE)

    return datetime_limit


def try_execute():
    try:
        datetime_limit = deletion_limit()
        history.delete_old(datetime_limit)
    except Exception:
        traceback.print_exc()
        error_reporting.Client(
            service="kraken_ohlc_clean."+ENVIRONMENT).report_exception()


if __name__ == "__main__":
    while True:
        try_execute()
        time.sleep(REFRESH_RATE)
