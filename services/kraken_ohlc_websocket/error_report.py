from kraken_socket.pipe import Pipe
import threading
from google.cloud import error_reporting
import os
import sys


ENVIRONMENT = os.getenv("BRUSHED_CHARTS_ENVIRONMENT")
SERVICE_NAME = "kraken_ohlc_websocket"


class ErrorReport(object):
    def __init__(self, pipe: Pipe):
        self.pipe = pipe

    def start(self):
        thread = threading.Thread(target=self.report)
        thread.start()

    def report(self):
        while True:
            error = self.pipe.error.get()
            print(error, file=sys.stderr)
            error_reporting.Client(
                service=f"{SERVICE_NAME}.{ENVIRONMENT}"
            ).report(message=error)
