from http.client import HTTPException
from requests import HTTPError
import responses
import unittest
from unittest import mock
from unittest.mock import MagicMock
from src import stream


class TestStream(unittest.TestCase):
    callback_mock = MagicMock()
    fake_url = 'http://fake-url.com'
    fake_body = '{"data": "hello"}\n{"data2": "hello2"}'

    @responses.activate
    @mock.patch.dict('os.environ', {"OANDA_API_TOKEN": "an-api-token"})
    def test_callback_on_valid_response(self):
        resp = self.make_mock_response(status=200)
        stream.listen(self.fake_url, self.callback_mock)
        assert self.callback_mock.call_count == 2
        self.cleanup_response(resp)

    def test_raise_on_empty_bearer_token(self):
        with self.assertRaises(ValueError):
            stream.listen(self.fake_url, self.callback_mock)

    @responses.activate
    @mock.patch.dict('os.environ', {"OANDA_API_TOKEN": "an-api-token"})
    def test_raise_on_http_error(self):
        resp = self.make_mock_response(status=404)
        with self.assertRaises((HTTPError, HTTPException)):
            stream.listen(self.fake_url, self.callback_mock)
        self.cleanup_response(resp)

    def cleanup_response(self, resp):
        resp.stop()
        resp.reset()

    def make_mock_response(self, status: int):
        resp = responses.RequestsMock()
        resp.start()
        resp.add(responses.GET, url=self.fake_url, body=self.fake_body, status=status)
        return resp
