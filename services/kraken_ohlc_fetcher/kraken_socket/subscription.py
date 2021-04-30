from websocket import create_connection
from kraken_socket.delay import Delay
from kraken_socket.pipe import Pipe
import threading
import time
import traceback
import message_analyzer

TIMEOUT = 5
URL = "wss://ws.kraken.com/"
QUERY = '''{
    "event":"subscribe",
    "subscription":{"name":"ohlc"},
    "pair":[
        "BTC/USD",
        "BTC/EUR",
        "ETH/EUR",
        "ETH/USD",
        "USDT/EUR",
        "XRP/EUR",
        "DOGE/EUR",
        "DOT/EUR",
        "UNI/EUR",
        "BCH/EUR",
        "USDC/EUR",
        "FIL/EUR",
        "TRX/EUR",
        "COMP/EUR",
        "DASH/EUR",
        "ZEC/EUR",
        "SNX/EUR",
        "ETH2/EUR",
        "ADA/EUR",
        "ADA/USD",
        "LTC/EUR",
        "XLM/EUR",
        "ETC/EUR",
        "EOS/EUR",
        "DAI/EUR"
    ]
}'''


class Subscription(object):
    def __init__(self, pipe: Pipe):
        self.pipe = pipe
        self.delay = Delay()

    def start(self):
        thread = threading.Thread(target=self.loop)
        thread.start()

    def loop(self):
        while True:
            self.try_connect()

    def try_connect(self):
        try:
            time.sleep(self.delay.get())
            self.connect()
        except Exception:
            self.pipe.error.put(traceback.format_exc())

    def connect(self):
        websocket = create_connection(URL)
        websocket.settimeout(TIMEOUT)
        websocket.send(QUERY)
        while True:
            self.read_message(websocket)

    def read_message(self, websocket):
        message = websocket.recv()
        self.raise_for_error_message(message)
        self.pipe.message.put(message)

    def raise_for_error_message(self, message):
        if message_analyzer.is_error(message):
            raise Exception(message)
