from queue import Queue


class Pipe(object):
    def __init__(self):
        self.message = Queue()
        self.error = Queue()
        self.error_state = False

    def write_error(self, error: str):
        self.error_state = True
        self.error.put(error)
