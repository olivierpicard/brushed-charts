import json
import os
import certifi

BINANCE_WATCHLIST_PATH = os.getenv('BINANCE_WATCHLIST_PATH')
TOKEN = os.getenv('OCI_USER_TOKEN_BRUSHED_CHARTS_APP')
TENANCY = os.getenv('OCI_TENANCY')
USERNAME = os.getenv('OCI_USER')
STREAMING_POOL = os.getenv('OCI_STREAMING_POOL_BINANCE')
STREAMING_SERVER = os.getenv('OCI_STREAMING_SERVER')


def load_config():
    file = open(BINANCE_WATCHLIST_PATH)
    data = json.load(file)
    file.close()
    return data


def get_kafka_config():
    return {
        'bootstrap.servers': STREAMING_SERVER,
        'security.protocol': 'SASL_SSL',
        'ssl.ca.location': certifi.where(),
        'sasl.mechanism': 'PLAIN',
        'sasl.username': f'{TENANCY}/{USERNAME}/{STREAMING_POOL}',
        'sasl.password': TOKEN,
        'compression.type': 'gzip',
        'linger.ms': '200'
    }


raw_data = load_config()
pairs = raw_data['pairs']
stream_types = raw_data['stream_types']