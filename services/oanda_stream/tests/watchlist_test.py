import unittest
from unittest.mock import mock_open, patch
from src import watchlist


class TestWatchlist(unittest.TestCase):

    @patch("builtins.open", new_callable=mock_open, read_data='{"pairs":["EUR_USD", "EUR_GBP"]}')
    def test_pairs_list_is_conform(self, _):
        assert watchlist.load_pairs('fake_path') == ["EUR_USD", "EUR_GBP"]

    def test_raise_on_absent_watchlist_file(self):
        with self.assertRaises(FileNotFoundError):
            watchlist.load_pairs('/fake/path')

    @patch("builtins.open", new_callable=mock_open, read_data='{"wrong_key":["EUR_USD"]}')
    def test_raise_on_key_not_found(self, _):
        with self.assertRaises(KeyError):
            watchlist.load_pairs('/fake/path')
