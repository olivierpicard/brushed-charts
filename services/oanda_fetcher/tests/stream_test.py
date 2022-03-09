from http.client import HTTPException
import unittest
from unittest import mock
from unittest.mock import MagicMock, patch
from urllib.error import HTTPError

from requests import Session
import stream


@patch.object(Session, 'get')
class TestStream(unittest.TestCase):
    callback_mock = MagicMock()
    fake_url = 'http://fake-url.com'

    @mock.patch.dict('os.environ', {"OANDA_API_TOKEN": "an-api-token"})
    def test_callback_on_valide_response(self, mock_get: MagicMock):
        mock_get.return_value.ok = True
        stream.listen(self.fake_url, self.callback_mock)
        self.callback_mock.assert_called()

    def test_raise_on_empty_bearer_token(self, _):
        with self.assertRaises(ValueError):
            stream.listen(self.fake_url, self.callback_mock)

    @mock.patch.dict('os.environ', {"OANDA_API_TOKEN": "an-api-token"})
    def test_raise_on_http_error(self, mock_get):
        mock_get.return_value.ok = False
        with self.assertRaises((HTTPError, HTTPException)):
            stream.listen(self.fake_url, self.callback_mock)
