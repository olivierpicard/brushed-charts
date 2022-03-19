import os
import traceback
import cloud_logger as clog
import watchlist
import url as urlconfig
import stream
import producer

publisher = None


def getenv(varname):
    return os.environ[varname]


def on_produder_error(err):
    error_message = {str(err)}
    log_body = {'message': error_message, 'cause': error_message}
    clog.write_log(log_body, severity=clog.Severity.WARNING)


def run():
    global publisher
    pairs = watchlist.load_pairs(getenv('OANDA_WATCHLIST_PATH'))
    url = urlconfig.build(getenv('OANDA_ACCOUNT_ID'), pairs)
    publisher = producer.Producer(error_callback=on_produder_error)
    stream.listen(url, publisher.diffuse)


def log_error_to_cloud(err: Exception):
    log_body = {'message': traceback.format_exc(), 'cause': str(err)}
    clog.write_log(log_body, severity=clog.Severity.ERROR)


def cleanup():
    try:
        publisher.prepare_exit()
    except Exception as err:
        log_error_to_cloud(err)


if __name__ == '__main__':
    try:
        run()
    except Exception as err:
        log_error_to_cloud(err)
    finally:
        cleanup()
