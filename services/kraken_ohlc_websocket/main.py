from kraken_socket.subscription import Subscription
from kraken_socket.pipe import Pipe
from error_report import ErrorReport

import message_analyzer
import watchlist
import candle_save
import parser
import traceback
import pymongo

pipe = Pipe()


def init_subscription(pairs: list[str]):
    subscription = Subscription(pipe, pairs)
    subscription.start()


def init_error():
    error_report = ErrorReport(pipe)
    error_report.start()


def save_to_db():
    while True:
        message = pipe.message.get()
        if not message_analyzer.is_ohlc(message):
            continue
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




if __name__ == "__main__":
    pairs = watchlist.get_asset_pairs()
    init_error()
    init_subscription(pairs)
    try_to_save_candle()
