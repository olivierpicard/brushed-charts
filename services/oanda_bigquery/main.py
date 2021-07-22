import time
import os
import history
import traceback
import copy
from google.cloud import bigquery, error_reporting

import reference_object as refobj
import lastupdate_log as log


REFRESH_RATE = 30  # seconds
PATH_PRICE_TABLE = os.getenv("OANDA_BIGQUERY_PATH_PRICE_TABLE")
ENVIRONMENT = os.getenv("BRUSHED_CHARTS_ENVIRONMENT")


class EmptyCandles(Exception):
  pass


def on_empty_candles(candles: list):
  if candles is None or len(candles) == 0:
      raise EmptyCandles


def remove_id(value: list):
  del value['_id']
  return value


def send_to_bigquery(candles: list):
  candle_copy = copy.deepcopy(candles)
  candle_copy = list(map(remove_id, candle_copy))
  client = bigquery.Client()
  client.insert_rows_json(PATH_PRICE_TABLE, candle_copy)
  client.close()


def execute():
  reference_object = log.read()
  candles = history.get_fresh_candles(reference_object)
  on_empty_candles(candles)
  send_to_bigquery(candles)
  log.save_last_reading_object(candles)


def try_to_execute():
  try:
    execute()
  except EmptyCandles or refobj.EmptyReferenceObject:
    pass
  except Exception:
    if ENVIRONMENT == 'dev': pass
    traceback.print_exc()
    error_reporting.Client(service="oanda_bigquery." +
                           ENVIRONMENT).report_exception()


if __name__ == "__main__":
  while True:
    try_to_execute()
    time.sleep(REFRESH_RATE)
