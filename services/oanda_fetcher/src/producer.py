import confluent_kafka as kafka
import certifi
import os


PROFIL = os.getenv("BRUSHED_CHARTS_ENVIRONMENT")
TOKEN = os.getenv('OCI_USER_TOKEN_BRUSHED_CHARTS_APP')
TENANCY = os.getenv('OCI_TENANCY')
USERNAME = os.getenv('OCI_USER')
STREAMING_POOL = os.getenv('OCI_STREAMING_POOL_BINANCE')
STREAMING_SERVER = os.getenv('OCI_STREAMING_SERVER')
TOPIC = f'oanda-raw-prices-{PROFIL}'


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
            'linger.ms': '200',
        })

    def diffuse(self, msg: str):
        self.kafka_producer.produce(
            TOPIC, value=msg, on_delivery=self.__delivery_report__)
        self.kafka_producer.poll(0)

    def __delivery_report__(self, err, _):
        if err is None:
            return
        self.error_callback(err)

    def prepare_exit(self):
        self.kafka_producer.flush()
        self.kafka_producer.close()
