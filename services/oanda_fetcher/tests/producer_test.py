import os
import unittest
from unittest.mock import MagicMock, patch


@patch('confluent_kafka.Producer')
@patch.dict(os.environ, {"BRUSHED_CHARTS_ENVIRONMENT": "dev"})
class TestProducer(unittest.TestCase):

    def produce_send_error(self, topic, value, on_delivery):
        err = Exception('an error')
        on_delivery(err, value)

    def test_if_message_is_transmitted_to_kafka(self, _):
        from src.producer import Producer
        error_callback = MagicMock()
        producer = Producer(error_callback)
        producer.diffuse('hello')
        producer.kafka_producer.poll.assert_called()
        producer.kafka_producer.produce.assert_called_with(
            'oanda-raw-prices-dev', value='hello', on_delivery=producer.__delivery_report__)
        error_callback.assert_not_called()

    def test_callback_when_diffusion_return_error(self, _):
        from src.producer import Producer
        error_callback = MagicMock()
        producer = Producer(error_callback)
        producer.kafka_producer.produce.side_effect = self.produce_send_error
        producer.diffuse('hello')
        error_callback.assert_called()
        assert isinstance(error_callback.call_args.args[0], Exception)
