import unittest
from src import url


class TestUrlMaker(unittest.TestCase):
    valid_pairs = ['EUR_USD', 'USD_JPY']
    valid_account_id = '1234-account_id-5432'

    def test_full_valid_url_is_valid(self):
        # pylama:ignore=E501
        expected = 'https://stream-fxpractice.oanda.com/v3/accounts/1234-account_id-5432/pricing/stream?instruments=EUR_USD,USD_JPY'
        stream_url = url.build(self.valid_account_id, self.valid_pairs)
        assert stream_url == expected

    def test_raise_on_invalid_accountID(self):
        with self.assertRaises(ValueError):
            url.build('', self.valid_pairs)

    def test_raise_on_None_accountID(self):
        with self.assertRaises(TypeError):
            url.build(None, self.valid_pairs)

    def test_raise_on_empty_pairs(self):
        with self.assertRaises(ValueError):
            url.build(self.valid_account_id, [])
