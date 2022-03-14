import unittest
from unittest.mock import MagicMock, patch

import confluent_kafka
from src.producer import Producer


@patch('confluent_kafka.Producer')
class TestProducer(unittest.TestCase):
    def test_if_message_is_transmitted_to_kafka(self, _):
        producer = Producer(None)
        producer.diffuse("hello")
        params = producer.producer.produce.call_args.kwargs
        assert params['value'] == 'hello'
        producer.producer.poll.assert_called()

    def test_callback_when_diffusion_return_error(self, _):
        pass

    def test_flush_before_exit(self, _):
        pass
