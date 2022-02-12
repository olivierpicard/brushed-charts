from threading import Timer
from datetime import datetime
import threading
import cloud_logger

# REFRESH_RATE = 5 * 60
REFRESH_RATE = 2

class RepeatTimer(Timer):
    def run(self):
        while not self.finished.wait(self.interval):
            self.function(*self.args, **self.kwargs)


class NoDataWatcher(threading.Thread):
    last_update_dt: datetime = None
    threshold_seconds = 0
    output_route_function = None
    repeated_timer = None

    def __init__(self, threshold_time_to_alert, output_function):
        self.threshold_seconds = threshold_time_to_alert
        self.output_route_function = output_function
        self.__update_watch_time__()
        self.repeated_timer = RepeatTimer(REFRESH_RATE, self.check_threshold)
        self.repeated_timer.start()

    def __update_watch_time__(self):
        self.last_update_dt = datetime.now()

    def on_fresh_data(self, msg):
        self.__update_watch_time__()
        self.output_route_function(msg)

    def check_threshold(self):
        elapsed_time = datetime.now() - self.last_update_dt
        elapsed_seconds = elapsed_time.total_seconds()
        if(elapsed_seconds >= self.threshold_seconds):
            self.on_threshold_reached()

    def on_threshold_reached(self):
        body_log = {
            'message': f'No data received since in {cloud_logger.LOG_NAME} since {self.threshold_seconds} seconds'}
        cloud_logger.write_log(body_log, severity='WARNING')

