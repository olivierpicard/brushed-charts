const MILLISECONDS = 1000

module.exports.update_dateFrom_with_lag = (args) => {
  const lag_date = get_lagged_date_from(args)
  args['dateFrom'] = lag_date

  return args
}

function get_lagged_date_from(args) {
  update_dateFrom_to_utc(args)
  const delta_lag = window_size_to_seconds_lag(args)
  const timestamp = get_lag_timestamp(args, delta_lag)
  const date_from = new Date(timestamp)
  const iso_lag_date = date_from.toISOString()
  
  return iso_lag_date
}

function window_size_to_seconds_lag(args) {
  const window_size = parseInt(args['windowSize'])
  const granularity = parseInt(args['granularity_origin'])
  const second_lag = window_size * granularity

  return second_lag
}

function get_lag_timestamp(args, lag) {
  const dateFrom = Date.parse(args['dateFrom'])
  console.log(dateFrom)
  const timestamp = dateFrom.valueOf()
  console.log(timestamp)
  const lag_timestamp = timestamp - lag * MILLISECONDS

  return lag_timestamp
}

function update_dateFrom_to_utc(args) {
  let dateFrom = args['dateFrom']
  dateFrom = dateFrom.toUpperCase()
  if (dateFrom.endsWith("Z")) return;
  args['dateFrom'] += 'Z'
}