import json
import os
import certifi
import confluent_kafka as kafka
import watchlist

TOPIC = 'oanda-raw-prices'
TOKEN = os.environ['OCI_USER_TOKEN_BRUSHED_CHARTS_APP']
TENANCY = os.environ['OCI_TENANCY']
USERNAME = os.environ['OCI_USER']
STREAMING_POOL = os.environ['OCI_STREAMING_POOL']
STREAMING_SERVER = os.environ['OCI_STREAMING_SERVER']

seconds_left = 35
expected_pairs = watchlist.get_essentials_pairs()
received_data = []

consumer = kafka.Consumer({
    'bootstrap.servers': STREAMING_SERVER,
    'security.protocol': 'SASL_SSL',
    'ssl.ca.location': certifi.where(),
    'sasl.mechanism': 'PLAIN',
    'sasl.username': f'{TENANCY}/{USERNAME}/{STREAMING_POOL}',
    'sasl.password': TOKEN,
    'group.id': 'integration-tester',
    'auto.offset.reset': "earliest",
    'session.timeout.ms': "30000"
})


def all_pairs_from_watchlist_were_received():
    received_pairs = list(map(lambda x: x['instrument'], received_data))
    not_received_pairs = list(filter(lambda x: x not in received_pairs, expected_pairs))
    print(f'not_received: {not_received_pairs}')
    print(f'received: {received_pairs}')
    print('--------')
    if len(not_received_pairs) == 0:
        return True
    return False


def decrease_time_on_empty_msg(msg: str):
    global seconds_left
    if msg is None or msg.error():
        seconds_left -= 1
        if seconds_left == 0:
            raise Exception(
                "Not all pairs from watchlist were present in time")


def handle_incomming_data(msg: str):
    if msg is None or msg.error():
        return
    json_msg = json.loads(msg.value().decode('utf-8'))
    received_data.append(json_msg)


if __name__ == '__main__':
    consumer.subscribe([TOPIC])
    while True:
        msg = consumer.poll(1.0)
        decrease_time_on_empty_msg(msg)
        handle_incomming_data(msg)
        if all_pairs_from_watchlist_were_received():
            print("All pairs from watchlist were received. It's OK !")
            break
