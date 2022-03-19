import os
import requests

OANDA_ACCOUNT_ID = os.getenv('OANDA_ACCOUNT_ID')
OANDA_TOKEN = os.getenv('OANDA_API_TOKEN')
OANDA_URL = os.getenv('OANDA_STREAM_URL')


header = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {OANDA_TOKEN}"
}
response = requests.get(
    f'{OANDA_URL}/v3/accounts/{OANDA_ACCOUNT_ID}/pricing/stream?instruments=EUR_USD,USD_CAD',
    headers=header, stream=True
)

response.raise_for_status()

for line in response.iter_lines():
    print(str(line))
