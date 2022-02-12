from google.cloud import logging
import os 

PROFIL = os.getenv('BRUSHED_CHARTS_ENVIRONMENT')
LOG_NAME = f'binance_rest_fetch.{PROFIL}'


def write_log(message: dict, severity: str) -> None:
    base_struct = {'serviceContext': {'service': LOG_NAME}}
    logger = logging.Client().logger(LOG_NAME)
    logger.log_struct(
        base_struct | message, severity=severity)