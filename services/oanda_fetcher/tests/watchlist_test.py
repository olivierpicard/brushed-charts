import os
import unittest
from unittest import mock
from unittest.mock import mock_open, patch

@patch("builtins.open", new_callable=mock_open, read_data='{"pairs":["EUR_USD", "EUR_GBP"]}')
@mock.patch.dict(os.environ, {'OANDA_WATCHLIST_PATH': 'fake_string'})
class TestWatchlist(unittest.TestCase):
    
    def test_pairs_list_is_conform(self, _):
        import watchlist
        assert watchlist.pairs == ["EUR_USD", "EUR_GBP"]

if __name__ == '__main__':
    unittest.main()