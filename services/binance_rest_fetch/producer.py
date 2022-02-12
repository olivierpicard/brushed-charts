import threading
import confluent_kafka as kafka
import os
import config

ENVIRONMENT = os.getenv("BRUSHED_CHARTS_ENVIRONMENT")

TOPIC = 'raw-data'
QUEUE_WAIT_TIMEOUT = 60

class Producer(threading.Thread):
    producer = None
    error_callback = None
    isRunning = True

    def __init__(self, error_callback) -> None:
        threading.Thread.__init__(self)
        self.error_callback = error_callback
        self.producer = self.__create_producer__()
        self.producer = kafka.Producer(config.get_kafka_config)


    def diffuse(self, dict_msg: dict):
        key = dict_msg['request_name']
        value = f'{dict_msg}'.encode('utf-8')
        self.producer.produce(TOPIC, value=value, key=key, on_delivery=self.__delivery_report__)
        self.producer.flush()


    def __delivery_report__(self, err, _):
        if err is None: return
        self.error_callback(err)