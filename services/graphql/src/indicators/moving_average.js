const { BigQuery } = require('@google-cloud/bigquery');
const { flat_source } = require('../price/flat_source')
const { prepare_input } = require('./prepare_input')
const { prepare_ouput } = require('./prepare_output')

module.exports.moving_average = async (args) => {
  args = flat_source(args, 'sourceSelector')
  input = prepare_input(args);
  query = make_query(args)
  bq_rows = await fetch(query)
  output = prepare_ouput(source, bq_rows)

  return output
}


function make_query(args) {
  if (args['source'] == 'oanda') {
    return make_query_oanda(args)
  }
  return make_query_kraken(args)
}


function make_query_kraken(args) {
  return `
  WITH moving_average AS(
      SELECT
          datetime,
          UNIX_SECONDS(TIMESTAMP(datetime)) AS timestamp,
          ROUND( 
              AVG(${args['ohlcAttribute']}) OVER(
              ORDER BY datetime
              ROWS BETWEEN ${args['windowSize'] - 1} PRECEDING AND CURRENT ROW
          ), 7) AS value
      FROM prod.kraken_ohlc_interval(
          ${args['granularity_origin']},
          TIMESTAMP("${args['dateFrom_lagged']}"),
          TIMESTAMP("${args['dateTo']}") )
      WHERE 
          asset_pair = "${args['asset']}"
          AND granularity = ${args['granularity']}
      ORDER BY datetime
  )

  SELECT *
  FROM moving_average
  WHERE datetime >= "${args['dateFrom']}"
  `
}

function make_query_oanda(args) {
  return `
  WITH moving_average AS(
      SELECT 
          date,
          UNIX_SECONDS(TIMESTAMP(date)) AS timestamp,
          ROUND( 
              AVG(mid.${args['ohlcAttribute']}) OVER(
              ORDER BY date
              ROWS BETWEEN ${args['windowSize'] - 1} PRECEDING AND CURRENT ROW
          ), 7) AS value
      FROM prod.oanda_prices_interval(
          ${args['granularity_origin']},
          TIMESTAMP("${args['dateFrom_lagged']}"),
          TIMESTAMP("${args['dateTo']}") )
      WHERE 
          instrument = "${args['asset']}"
          AND granularity = "${args['granularity']}"
      order by date
  )

  SELECT *
  FROM moving_average
  WHERE date >= "${args['dateFrom']}"
  `
}

async function fetch(query) {
  const bigquery = new BigQuery();
  const [job] = await bigquery.createQueryJob(query);
  const [rows] = await job.getQueryResults();

  return rows
}
