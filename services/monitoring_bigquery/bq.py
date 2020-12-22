from datetime import datetime
from typing import List, Dict
from google.cloud import bigquery, error_reporting

INSTRUMENT = "EUR_USD"
GRANULARITY = "S5"

def presence_from_date(table_path: str, date: datetime):
    client = bigquery.Client()
    query = make_query(table_path, date)
    result = client.query(query)
    
    


def make_query(table_path: str, date: datetime):
    query = """
    SELECT date
    FROM `{}` 
    WHERE 
        granularity = "{}" AND
        instrument = "{}" AND
        date >= {}
    """.format(
        table_path,
        GRANULARITY,
        INSTRUMENT,
        date)

    return query

