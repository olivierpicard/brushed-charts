# pylama:ignore=E501
import os
import unittest
import responses
from unittest.mock import MagicMock, mock_open, patch, call

import watchlist as watchlist
import url as urlconfig
import stream as stream


@patch.dict('os.environ', {"OANDA_ACCOUNT_ID": "an-api-token"})
@patch.dict('os.environ', {"BRUSHED_CHARTS_ENVIRONMENT": "dev"})
@patch.dict('os.environ', {"OCI_USER_TOKEN_BRUSHED_CHARTS_APP": "oci-user-token"})
@patch.dict('os.environ', {"OCI_TENANCY": "oci-tenancy"})
@patch.dict('os.environ', {"OCI_USER": "oci-user"})
@patch.dict('os.environ', {"OCI_STREAMING_POOL": "oci-streaming-pool"})
@patch.dict('os.environ', {"OCI_STREAMING_SERVER": "oci-stream-server"})
@patch.dict('os.environ', {"OANDA_API_TOKEN": "an-api-token"})
class TestIntegration(unittest.TestCase):
    correct_url = 'https://stream-fxpractice.oanda.com/v3/accounts/an-api-token/pricing/stream?instruments=EUR_USD,EUR_GBP'
    mock_body = '{"type": "PRICE", "instrument": "EUR_USD", "price": 1.2345}\n\
{"type": "PRICE", "instrument": "EUR_GBP", "price": 0.345}'

    def make_mock_response(self, status: int):
        responses.add(responses.GET, url=self.correct_url,
                      body=self.mock_body, status=status)

    def list_of_expected_calls(self, publisher_callback):
        topic = 'oanda-raw-prices'
        return [
            call(topic, key='EUR_USD', value='{"type": "PRICE", "instrument": "EUR_USD", "price": 1.2345}'.encode('utf-8'),
                 on_delivery=publisher_callback),
            call(topic, key='EUR_GBP', value='{"type": "PRICE", "instrument": "EUR_GBP", "price": 0.345}'.encode('utf-8'),
                 on_delivery=publisher_callback),
        ]

    @patch("builtins.open", new_callable=mock_open, read_data='{"pairs":["EUR_USD", "EUR_GBP"]}')
    def test_integration_watchlitst_and_url(self, _):
        pairs = watchlist.load_pairs('a/fake/path')
        url = urlconfig.build(os.environ['OANDA_ACCOUNT_ID'], pairs)
        assert url == self.correct_url

    @responses.activate
    @patch('confluent_kafka.Producer')
    def test_integration_stream_producer(self, _):
        import producer as producer
        self.make_mock_response(status=200)
        publisher = producer.Producer(MagicMock())
        stream.listen(self.correct_url, publisher.diffuse)
        calls = self.list_of_expected_calls(publisher.__delivery_report__)
        publisher.kafka_producer.produce.assert_has_calls(calls)
