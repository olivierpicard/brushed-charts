from kraken_socket.subscription import Subscription
from kraken_socket.pipe import Pipe
from error_report import ErrorReport
import parser

TIMEOUT = 20
QUERY = '{"event":"subscribe", "subscription":{"name":"ohlc"}, "pair":["BTC/USD","BTC/EUR","ETH/EUR","ETH/USD","XRP/EUR","ADA/EUR","ADA/USD","LTC/EUR","XLM/EUR","ETC/EUR","EOS/EUR","DAI/EUR"]}'

pipe = Pipe()

def init_subscription():
    subscription = Subscription(QUERY, pipe)
    subscription.start()


def init_error():
    error_report = ErrorReport(pipe)
    error_report.start()

def save_to_db():
    while True:
        message = pipe.message.get()
        if not parser.is_ohlc(message): continue
        parser.give_column_name(message)

if __name__ == "__main__":
    init_error()
    init_subscription()
    save_to_db()
