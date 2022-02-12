from queue import Empty, Queue
import threading
import traceback
import confluent_kafka as kafka
import certifi
import os
from google.cloud import error_reporting

ENVIRONMENT = os.getenv("BRUSHED_CHARTS_ENVIRONMENT")
TOKEN = os.getenv('OCI_USER_TOKEN_BRUSHED_CHARTS_APP')
TENANCY = os.getenv('OCI_TENANCY')
USERNAME = os.getenv('OCI_USER')
STREAMING_POOL = os.getenv('OCI_STREAMING_POOL_BINANCE')
STREAMING_SERVER = os.getenv('OCI_STREAMING_SERVER')
TOPIC = 'raw-data'


class Producer(threading.Thread):
    producer = None
    error_callback = None
    queue = Queue()
    isRunning = True

    def __init__(self, error_callback) -> None:
        threading.Thread.__init__(self)
        self.error_callback = error_callback
        self.producer = self.__create_producer__()

    def __create_producer__(self):
        return kafka.Producer({
            'bootstrap.servers': STREAMING_SERVER,
            'security.protocol': 'SASL_SSL',
            'ssl.ca.location': certifi.where(),
            'sasl.mechanism': 'PLAIN',
            'sasl.username': f'{TENANCY}/{USERNAME}/{STREAMING_POOL}',
            'sasl.password': TOKEN,
            'compression.type': 'snappy',
            'linger.ms': '200',
        })


    def __diffuse__(self, dict_msg: dict):
        key = dict_msg['stream']
        value = f'{dict_msg}'.encode('utf-8')
        self.producer.produce(TOPIC, value=value, key=key, on_delivery=self.__delivery_report__)
        self.producer.poll(0)


    def __delivery_report__(self, err, _):
        if err is None: return
        self.error_callback(err)


    def push_update(self, dict_msg: dict):
        self.queue.put(dict_msg)


    def run(self):
        while self.isRunning:
            try:
                msg = self.queue.get(block=True, timeout=2)
                self.__diffuse__(msg)
            except Empty:
                pass
            except Exception as err:
                traceback.print_exc()
                error_reporting.Client(service="oanda_history."+ENVIRONMENT).report_exception()
