import sys
from google.cloud import logging
import os


class Severity:
    CRITICAL = 'CRITICAL'
    ERROR = 'ERROR'
    WARNING = 'WARNING'
    INFO = 'INFO'


PROFIL = os.environ['BRUSHED_CHARTS_ENVIRONMENT']
LOG_NAME = f'oanda_stream.{PROFIL}'


def write_log(message: dict, severity: str) -> None:
    base_struct = {'serviceContext': {'service': LOG_NAME}, 'profil': PROFIL}
    full_log = base_struct | message
    logging_if_dev_profil(full_log, severity)


def logging_if_dev_profil(full_log: dict, severity: str) -> None:
    if PROFIL != 'dev':
        return
    print(full_log['message'], file=sys.stderr)
    print(f'severity: {severity}', file=sys.stderr)



def logging_if_not_dev_profil(full_log: dict, severity: str) -> None:
    if PROFIL == 'dev':
        return
    logger = logging.Client().logger(LOG_NAME)
    logger.log_struct(
        full_log, severity=severity)
