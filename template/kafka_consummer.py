from confluent_kafka import Consumer
import certifi
import os

TOKEN = os.getenv('OCI_USER_TOKEN_BRUSHED_CHARTS_APP')
TENANCY = os.getenv('OCI_TENANCY')
USERNAME = os.getenv('OCI_USER')
STREAMING_POOL = os.getenv('OCI_STREAMING_POOL')
STREAMING_SERVER = os.getenv('OCI_STREAMING_SERVER')
TOPIC = 'oanda-raw-prices'

consumer = Consumer({
    'bootstrap.servers': STREAMING_SERVER,
    'security.protocol': 'SASL_SSL',
    'ssl.ca.location': certifi.where(),
    'sasl.mechanism': 'PLAIN',
    'sasl.username': f'{TENANCY}/{USERNAME}/{STREAMING_POOL}',
    'sasl.password': TOKEN,
    'group.id': 'end-to-end-tester',
    'auto.offset.reset': "earliest",
    'session.timeout.ms': "30000",
})

consumer.subscribe([TOPIC])

# Process messages
try:
    while True:
        msg = consumer.poll(1.0)
        if msg is None:
            continue
        elif msg.error():
            print("Consumer error: {}".format(msg.error()))
            continue
        print('{}'.format(msg.value().decode('utf-8')))

except KeyboardInterrupt:
    pass
finally:
    print("Leave group and commit final offsets")
    consumer.close()
