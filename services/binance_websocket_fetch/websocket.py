from os import environ
from binance.websocket.spot.websocket_client import SpotWebsocketClient as Client
import config

wss_url = environ.get('BINANCE_WEBSOCKET_URL')
ws_client = Client(wss_url)


def __make_list_of_pairs_by_stream__(stream_type, pairs):
    return list(map(lambda pair: pair + stream_type, pairs))


def __make_list_of_streams__(stream_types, pairs):
    stream_names = list()
    for type in stream_types:
        stream_names += __make_list_of_pairs_by_stream__(type, pairs)
    return stream_names


def start(callback):
    ws_client.start()
    ws_client.instant_subscribe(
        stream=__make_list_of_streams__(config.stream_types, config.pairs),
        callback=callback,
    )

def stop():
    ws_client.stop()

