from datetime import datetime
import os
from typing import List, Dict
from google.cloud import bigquery, error_reporting

BIGQUERY_TABLE_PATH = os.getenv("BIGQUERY_TABLE_PATH_TO_MONITOR_PRESENCE")

def get_presence_from_date_window(window: (datetime, datetime)):
    client = bigquery.Client()
    query = make_query(window)
    results = client.query(query).result()
    parsed_result = convert_bigquery_results_to_JSON(results)
    
    return parsed_result


def make_query(window: (datetime, datetime)):
    parsed_date_from, parsed_date_to = date_window_parser(window)
    query = """
    SELECT date, instrument, granularity
    FROM `{}` 
    WHERE 
        date > "{}" AND
        date <= "{}"
    """.format(
        BIGQUERY_TABLE_PATH,
        parsed_date_from,
        parsed_date_to)

    return query


def date_window_parser(window: (datetime, datetime)):
    parsed_date_from = str(window[0]).replace(" ", "T")
    parsed_date_to = str(window[1]).replace(" ", "T")

    return (parsed_date_from, parsed_date_to)


def convert_bigquery_results_to_JSON(results: bigquery.table.RowIterator):
    parsed_result = list()
    for row in results:
        row_to_dict = {}
        row_to_dict['date'] = row[0]
        row_to_dict['instrument'] = row[1]
        row_to_dict['granularity'] = row[2]
        parsed_result.append(row_to_dict)
    
    return parsed_result