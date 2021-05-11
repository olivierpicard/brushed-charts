from google.cloud import bigquery as gbigquery
from bigquery import oanda_prices
from bigquery import kraken_ohlc


def get_status():
    client = gbigquery.Client()
    oanda_status = oanda_prices.get_last_update_status(client)
    kraken_status = kraken_ohlc.get_last_update_status(client)
    status = [oanda_status, kraken_status]

    return status
