import json
import os
import queue
from threading import Thread
import certifi
import confluent_kafka as kafka

TOPIC = 'oanda-raw-prices'
TOKEN = os.environ['OCI_USER_TOKEN_BRUSHED_CHARTS_APP']
TENANCY = os.environ['OCI_TENANCY']
USERNAME = os.environ['OCI_USER']
STREAMING_POOL = os.environ['OCI_STREAMING_POOL']
STREAMING_SERVER = os.environ['OCI_STREAMING_SERVER']


class ThreadedConsumerKafka(Thread):
    json_queue = queue.Queue()
    consumer = kafka.Consumer({
        'bootstrap.servers': STREAMING_SERVER,
        'security.protocol': 'SASL_SSL',
        'ssl.ca.location': certifi.where(),
        'sasl.mechanism': 'PLAIN',
        'sasl.username': f'{TENANCY}/{USERNAME}/{STREAMING_POOL}',
        'sasl.password': TOKEN,
        'group.id': 'end-to-end-tester',
        'auto.offset.reset': "earliest",
        'session.timeout.ms': "30000"
    })

    def run(self):
        self.consumer.subscribe([TOPIC])
        try:
            self.__consume_loop__()
        finally:
            print("Leave group and commit final offsets")
            self.consumer.close()

    def __consume_loop__(self):
        while True:
            msg = self.consumer.poll(1.0)
            if msg is None or msg.error():
                continue
            json_msg = json.loads(msg.value().decode('utf-8'))
            self.json_queue.put(json_msg)
