import os
import re
from google.cloud import error_reporting

ACCOUNT_ID = os.getenv('OANDA_ACCOUNT_ID')
API_URL = os.getenv('OANDA_API_URL')
URL_LATEST_CANDLE = API_URL + "/v3/accounts/" + ACCOUNT_ID + "/candles/latest"


