import os
import unittest
from unittest.mock import MagicMock, patch


@patch('confluent_kafka.Producer')
class TestProducer(unittest.TestCase):

    def produce_send_error(topic, value, on_delivery):
        import confluent_kafka
        err = confluent_kafka.KafkaException("an error")
        on_delivery(err)
        print("okok")

    @patch.dict(os.environ, {"BRUSHED_CHARTS_ENVIRONMENT": "dev"})
    def test_if_message_is_transmitted_to_kafka(self, _):
        from src.producer import Producer
        producer = Producer(None)
        producer.diffuse('hello')
        producer.kafka_producer.poll.assert_called()
        producer.kafka_producer.produce.assert_called_with(
            'oanda-raw-prices-dev', value='hello', on_delivery=producer.__delivery_report__)

    @patch.dict(os.environ, {"BRUSHED_CHARTS_ENVIRONMENT": "dev"})
    def test_callback_when_diffusion_return_error(self, _):
        import confluent_kafka
        from src.producer import Producer
        error_callback = MagicMock()
        producer = Producer(error_callback)
        producer.kafka_producer.produce.side_effect = self.produce_send_error
        producer.diffuse('hello')
        error_callback.assert_called_with(confluent_kafka.KafkaException('an error'))

    # def test_flush_before_exit(self, _):
    #     pass
