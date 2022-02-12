from google.cloud import logging
from producer import Producer
import websocket

LOG_NAME = 'binance_websocket_fetch'


def on_error(err, msg):
    logger = logging.Client().logger(LOG_NAME)
    logger.log_struct({
        'error': str(err),
        'message': msg
    }, severity="WARNING")


def start():
    producer = Producer(error_callback=on_error)
    producer.start()
    websocket.start(callback=producer.push_update)


if __name__ == "__main__":
    start()
