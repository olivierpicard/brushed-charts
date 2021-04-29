import time
import threading


MAX_DELAY = 20  # seconds
MIN_DELAY = 0.1  # seconds


class Delay(object):
    def __init__(self):
        self.delay = MIN_DELAY
        self.attempt = 0
        self.thread = threading.Thread(target=self.decrease_loop)
        self.thread.start()

    def update(self):
        self.delay = MIN_DELAY * 2 ** self.attempt

    def get(self):
        self.increase()
        return self.delay

    def increase(self):
        if self.delay >= MAX_DELAY: return
        self.attempt += 1
        self.update()

    def decrease_loop(self):
        while True:
            self.decrease()
            time.sleep(120)  # 2 minutes

    def decrease(self):
        if self.attempt > 0:
            self.attempt -= 1
        self.update()
