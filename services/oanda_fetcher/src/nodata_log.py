from datetime import datetime


class NoDataLog:
    CHECK_INTERVAL = 60*5

    def __init__(self, threshold, next):
        self.time_data_was_received = datetime.now()
        self.next = next
        self.threshold = threshold

    def on_incoming_data(input):
        if input == '' or input is None:
            return
