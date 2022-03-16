from src.nodata_log import NoDataLog


class TestProducer(unittest.TestCase):

    def test_raise_when_threshold_is_reach(self):
        NoDataLog(5, None)

    def test_datetime_updated_and_no_error_raised(self):
        pass
