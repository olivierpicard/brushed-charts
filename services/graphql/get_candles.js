const { BigQuery } = require('@google-cloud/bigquery');
const { prepare_input } = require('./prepare_input');
const { prepare_ouput } = require('./prepare_output');
const { query_maker } = require('./query_maker')

module.exports.getCandles = async (args) => {
  input = prepare_input(args)
  query = query_maker(input)
  console.log(query)
  bq_rows = await fetch(query)
  output = prepare_ouput(input['source'], bq_rows)

  return output
}


async function fetch(query) {
  const bigquery = new BigQuery();
  const [job] = await bigquery.createQueryJob(query);
  const [rows] = await job.getQueryResults();

  return rows
}

