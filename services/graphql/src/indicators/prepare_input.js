const { prepare_input: prepare_source_input } = require('../price/prepare_input.js')
const { update_dateFrom_with_lag } = require('./lag_date_from.js')

module.exports.prepare_input = (args) => {
  input = make_columns(args)
  input['granularity_origin'] = input['granularity']
  input = prepare_source_input(input)
  input = update_dateFrom_with_lag(input)

  return input
}

function make_columns(args) {
  const columns = []
  const ohlc_attribute = args['ohlcAttribute']
  columns.push('datetime')
  columns.push(ohlc_attribute)
  args['columns'] = columns

  return args
}
