import time
import traceback
import cloud_logger

from producer import Producer
from book_snapshot import BookSnapshot
from services.binance_rest_fetch.nodata_watcher import NoDataWatcher

REFRESH_RATE = 30 * 60  # seconds


def on_error(err, msg):
    log_body = {'error': str(err), 'message': msg}
    cloud_logger.write_log(message=log_body, severity="WARNING")


def try_execute():
    try:
        producer = Producer(error_callback=on_error)
        nodata_alerter = NoDataWatcher(REFRESH_RATE, output_function=producer.diffuse)
        book_snapshot = BookSnapshot(callback=nodata_alerter.on_fresh_data)
        book_snapshot.get_all_depths()
    except InterruptedError:
        pass
    except Exception:
        log_body = {'message': traceback.format_exc()},
        cloud_logger.write_log(log_body, severity="ERROR")


if __name__ == "__main__":
    while True:
        try_execute()
        time.sleep(REFRESH_RATE)
