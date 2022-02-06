from encodings import utf_8
from time import sleep
from confluent_kafka import Producer
import certifi
import os

TOKEN = os.getenv('OCI_USER_TOKEN_BRUSHED_CHARTS_APP')
TENANCY = os.getenv('OCI_TENANCY')
USERNAME = os.getenv('OCI_USER')
STREAMING_POOL = os.getenv('OCI_STREAMING_POOL_BINANCE')
STREAMING_SERVER = os.getenv('OCI_STREAMING_SERVER')
TOPIC = 'raw-data'


class Kafka(object):
    producer = None
    error_callback = None

    def __init__(self, error_callback) -> None:
        self.error_callback = error_callback
        self.producer = Producer({
            'bootstrap.servers': STREAMING_SERVER,
            'security.protocol': 'SASL_SSL',
            'ssl.ca.location': certifi.where(),
            'sasl.mechanism': 'PLAIN',
            'sasl.username': f'{TENANCY}/{USERNAME}/{STREAMING_POOL}',
            'sasl.password': TOKEN,
            'compression.type': 'snappy',
            'linger.ms': '100',
        })

    def diffuse(self, dict_msg: dict):
        key = dict_msg['stream']
        value = f'{dict_msg}'.encode('utf-8')
        self.producer.produce(TOPIC, value=value, key=key, on_delivery=self.__delivery_report__)
        self.producer.poll(0)

    def __delivery_report__(self, err, _):
        if err is None: return
        self.error_callback(err)

    def flush(self):
        self.producer.flush()
