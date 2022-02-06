import websocket
from kafka import Kafka

def on_producer_error(err):
    print(err)

def message_handler(msg):
    print(msg)

if __name__ == "__main__":
    producer = Kafka(on_producer_error)
    websocket.start(callback=producer.diffuse)
    