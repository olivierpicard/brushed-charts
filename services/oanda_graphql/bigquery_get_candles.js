const { BigQuery, BigQueryTimestamp } = require('@google-cloud/bigquery');
const BIGQUERY_TABLE_PATH_PRICE_SHORTTERM = process.env['OANDA_BIGQUERY_PATH_TABLE_SHORTTERM']
const BIGQUERY_TABLE_PATH_PRICE_ARCHIVE = process.env['OANDA_BIGQUERY_PATH_TABLE_ARCHIVE']

var dateFrom, dateTo, granularity, instrument, source


module.exports.getBigqueryCandles = async (args) => {
  dateFrom = args['dateFrom']
  dateTo = args['dateTo']
  granularity = args['granularity']
  instrument = args['instrument']
  source = args['source'] // e.g: brushed-charts.oanda_test.price_shortterm

  query = make_query()
  result = await fetch(query)
  prepare_output(result)
  
  return result
}


function make_query() {
  tableName = get_appropriate_table_name_baseon_date(dateFrom, dateTo)

  const query = `
  SELECT * 
  FROM \`${tableName}\` 
  WHERE 
    granularity = "${granularity}" AND 
    instrument = "${instrument}" AND 
    date >= "${dateFrom}" AND date < "${dateTo}"
  `
  
  return query
}


function get_appropriate_table_name_baseon_date() {
  const DAYS_130 = 130*24*60*60*1000 // Days in milliseconds
  const now = new Date()
  const datetimeFrom = new Date(Date.parse(dateFrom))
  const diff = Math.abs(now - datetimeFrom)
  
  if (source) return source
  if (diff >= DAYS_130)
    return BIGQUERY_TABLE_PATH_PRICE_ARCHIVE
  
  return BIGQUERY_TABLE_PATH_PRICE_SHORTTERM
}


async function fetch(query) {
  const bigquery = new BigQuery();
  const [job] = await bigquery.createQueryJob(query);
  const [rows] = await job.getQueryResults();

  return rows
}


function prepare_output(result) {
  for (var i = 0; i < result.length; i++) {
    var row = result[i]
    parse_datetime(row)
    add_field_mid(row)
    add_field_spread(row)
  }
}


function parse_datetime(row) {
  let datetime_str = row['date']['value']
  row['date'] = datetime_str
}


function add_field_mid(row) {
  const mid = {
    open: (row['ask']['open'] + row['bid']['open']) / 2,
    high: (row['ask']['high'] + row['bid']['high']) / 2,
    low: (row['ask']['low'] + row['bid']['low']) / 2,
    close: (row['ask']['close'] + row['bid']['close']) / 2
  }

  row['mid'] = mid
}


function add_field_spread(row) {
  const spread = {
    open: row['ask']['open'] - row['bid']['open'],
    high: row['ask']['high'] - row['bid']['high'],
    low: row['ask']['low'] - row['bid']['low'],
    close: row['ask']['close'] - row['bid']['close']
  }

  row['spread'] = spread
}