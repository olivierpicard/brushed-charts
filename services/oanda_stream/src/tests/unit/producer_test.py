import unittest
from unittest.mock import MagicMock, patch


@patch('confluent_kafka.Producer')
@patch.dict('os.environ', {"BRUSHED_CHARTS_ENVIRONMENT": "dev"})
@patch.dict('os.environ', {"OCI_USER_TOKEN_BRUSHED_CHARTS_APP": "oci-user-token"})
@patch.dict('os.environ', {"OCI_TENANCY": "oci-tenancy"})
@patch.dict('os.environ', {"OCI_USER": "oci-user"})
@patch.dict('os.environ', {"OCI_STREAMING_POOL": "oci-streaming-pool"})
@patch.dict('os.environ', {"OCI_STREAMING_SERVER": "oci-stream-server"})
class TestProducer(unittest.TestCase):
    message_to_diffuse = {"instrument": "EUR_USD", "price": 1.345}
    encoded_message = '{"instrument": "EUR_USD", "price": 1.345}'.encode('utf-8')

    def produce_send_error(self, topic, key, value, on_delivery):
        err = Exception('an error')
        on_delivery(err, value)

    def test_if_message_is_transmitted_to_kafka(self, _):
        from producer import Producer
        error_callback = MagicMock()
        producer = Producer(error_callback)
        producer.diffuse(self.message_to_diffuse)
        producer.kafka_producer.poll.assert_called()
        producer.kafka_producer.produce.assert_called_with(
            'oanda-raw-prices', value=self.encoded_message,
            key='EUR_USD',
            on_delivery=producer.__delivery_report__)
        error_callback.assert_not_called()

    def test_callback_when_diffusion_return_error(self, _):
        from producer import Producer
        error_callback = MagicMock()
        producer = Producer(error_callback)
        producer.kafka_producer.produce.side_effect = self.produce_send_error
        producer.diffuse(self.message_to_diffuse)
        error_callback.assert_called()
        assert isinstance(error_callback.call_args.args[0], Exception)
