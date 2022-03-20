import json
import confluent_kafka as kafka
import certifi
import os


TOKEN = os.environ['OCI_USER_TOKEN_BRUSHED_CHARTS_APP']
TENANCY = os.environ['OCI_TENANCY']
USERNAME = os.environ['OCI_USER']
STREAMING_POOL = os.environ['OCI_STREAMING_POOL']
STREAMING_SERVER = os.environ['OCI_STREAMING_SERVER']
TOPIC = 'oanda-raw-prices'


class Producer():
    kafka_producer = None
    error_callback = None

    def __init__(self, error_callback) -> None:
        self.error_callback = error_callback
        self.kafka_producer = self.__create_producer__()

    def __create_producer__(self):
        return kafka.Producer({
            'bootstrap.servers': STREAMING_SERVER,
            'security.protocol': 'SASL_SSL',
            'ssl.ca.location': certifi.where(),
            'sasl.mechanism': 'PLAIN',
            'sasl.username': f'{TENANCY}/{USERNAME}/{STREAMING_POOL}',
            'sasl.password': TOKEN,
            'compression.type': 'snappy',
            'request.timeout.ms': 5000,
            'delivery.timeout.ms': 10000,
            'linger.ms': '200',
        })

    def diffuse(self, msg: dict):
        encoded_message = json.dumps(msg).encode('utf-8')
        instrument = msg['instrument']
        self.kafka_producer.produce(
            TOPIC, key=instrument,
            value=encoded_message,
            on_delivery=self.__delivery_report__
        )
        self.kafka_producer.poll(0)

    def __delivery_report__(self, err, _):
        if err is None:
            return
        self.error_callback(err)

    def prepare_exit(self):
        self.kafka_producer.flush()
