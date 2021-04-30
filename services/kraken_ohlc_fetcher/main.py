from kraken_socket.subscription import Subscription
from kraken_socket.pipe import Pipe
from error_report import ErrorReport

import message_analyzer
import candle_save
import parser
import traceback
import os
import pymongo

GRANULARITY = os.getenv("KRAKEN_OHLC_GRANULARITY")

pipe = Pipe()


def init_subscription():
    subscription = Subscription(pipe)
    subscription.start()


def init_error():
    error_report = ErrorReport(pipe)
    error_report.start()


def save_to_db():
    while True:
        message = pipe.message.get()
        if not message_analyzer.is_ohlc(message): continue
        json_candle = parser.give_column_name(message)
        candle_save.save(json_candle)


def try_to_save_candle():
    while True:
        try:
            save_to_db()
        except pymongo.errors.DuplicateKeyError:
            pass
        except:
            pipe.error.put(traceback.format_exc())


def check_granularity():
    if GRANULARITY is not None and GRANULARITY != '':
        return
    message = 'GRANULARITY environment variable is unset'
    pipe.error.put(message)
    raise Exception(message)


if __name__ == "__main__":
    check_granularity()
    init_error()
    init_subscription()
    try_to_save_candle()
