from websocket import create_connection
from kraken_socket.delay import Delay
from kraken_socket.pipe import Pipe
import threading
import time
import traceback
import message_analyzer
import os


TIMEOUT = 5
URL = "wss://ws.kraken.com/"
GRANULARITY = int(os.getenv("KRAKEN_OHLC_GRANULARITY"))  # minutes


class Subscription(object):
    def __init__(self, pipe: Pipe, pairs: list[str]):
        self.pipe = pipe
        self.pairs = pairs
        self.query = self.build_query()
        self.delay = Delay()

    def build_query(self) -> str:
        joined_pairs = ','.join(self.pairs).replace('\n', '')
        query = f'''{{
            "event": "subscribe",
            "subscription": {{"name":"ohlc", "interval": {GRANULARITY}}},
            "pair": [{joined_pairs}]
}}'''

        return query

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
        websocket.send(self.query)
        while True:
            self.read_message(websocket)

    def read_message(self, websocket):
        message = websocket.recv()
        self.raise_for_error_message(message)
        self.pipe.message.put(message)

    def raise_for_error_message(self, message):
        if message_analyzer.is_error(message):
            raise Exception(message)
