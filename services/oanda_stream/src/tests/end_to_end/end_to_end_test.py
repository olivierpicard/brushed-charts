import multiprocessing
import os
from queue import Empty
from time import sleep
import unittest
from consumer_kafka import ThreadedConsumerKafka
import watchlist
import main as entrypoint

"""
To execute this test you should use the PROFIL test or dev NOT prod
OCI topic must be created before to run this test.
If it's not created before the auto creation take to much time and the test will fail
Interval of at least 30 seconds should be left before relaunch this app
"""

PROFIL = os.environ['BRUSHED_CHARTS_ENVIRONMENT']
WATCHLIST_PATH = os.environ['OANDA_WATCHLIST_PATH']


class EndToEndTest(unittest.TestCase):
    prog_to_test = multiprocessing.Process(
        target=entrypoint.start, daemon=True)
    kafka_consumer = ThreadedConsumerKafka(daemon=True)
    retrieved_data = kafka_consumer.json_queue
    pairs: list = watchlist.load_pairs(WATCHLIST_PATH)
    unique_instrument_name = set()

    def test_all_module_without_mock(self):
        assert PROFIL != 'prod'
        self.kafka_consumer.start()
        self.empty_consumer_before_test()
        self.prog_to_test.start()
        sleep(4)
        self.prog_to_test.terminate()
        self.make_assertion_on_retrieved_kafka_data()

    def empty_consumer_before_test(self):
        try:
            while True:
                self.retrieved_data.get(block=True, timeout=3)
        except Empty:
            pass

    def make_assertion_on_retrieved_kafka_data(self):
        try:
            while True:
                json_data = self.retrieved_data.get(block=False)
                self.make_assertion_line_by_line(json_data)
                self.add_to_unique_intrument_name_set(json_data)
        except Empty:
            self.assert_all_watchlist_pairs_was_used()

    def make_assertion_line_by_line(self, json_data):
        assert 'instrument' in json_data.keys()
        assert json_data['type'] == 'PRICE'
        assert self.instrument_is_in_watchlist(json_data['instrument'])

    def instrument_is_in_watchlist(self, instrument_name: str) -> bool:
        if instrument_name in self.pairs:
            return True
        return False

    def add_to_unique_intrument_name_set(self, json_data):
        self.unique_instrument_name.add(
            json_data['instrument'])

    def assert_all_watchlist_pairs_was_used(self):
        unique_pairs = set(self.pairs)
        diff_pairs = unique_pairs.difference(self.unique_instrument_name)
        assert len(diff_pairs) == 0
