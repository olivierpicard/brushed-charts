from websocket import create_connection
from kraken_socket.delay import Delay
from kraken_socket.pipe import Pipe
import threading
import time
import traceback
import parser

TIMEOUT = 2
URL = "wss://ws.kraken.com/"


class Subscription(object):
    def __init__(self, query: str, pipe: Pipe):
        self.pipe = pipe
        self.query = query
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
        websocket.send(self.query)
        while True:
            self.read_message(websocket)

    def read_message(self, websocket):
        message = websocket.recv()
        self.raise_for_error_message(message)
        self.pipe.message.put(message)

    def raise_for_error_message(self, message):
        if parser.is_error(message):

            raise Exception(message)
