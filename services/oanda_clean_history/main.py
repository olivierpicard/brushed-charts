import time
import history
import os
import traceback
from google.cloud import error_reporting
from datetime import datetime, timedelta

REFRESH_RATE = 60 * 30  # In seconds
DELETE_FROM_DATE = int(os.getenv("OANDA_CLEAN_HISTORY_FROM_DAYS"))
ENVIRONMENT = os.getenv("BRUSHED_CHARTS_ENVIRONMENT")

def deletion_limit(days: int) -> datetime:
    datetime_limit = datetime.utcnow() - timedelta(days=days)

    return datetime_limit


def try_execute():
    try:
        datetime_limit = deletion_limit(DELETE_FROM_DATE)
        history.delete_old(datetime_limit)
    except Exception:
        traceback.print_exc()
        error_reporting.Client(service="oanda_history."+ENVIRONMENT).report_exception()


if __name__ == "__main__":
    while True:
        try_execute()
        time.sleep(REFRESH_RATE)