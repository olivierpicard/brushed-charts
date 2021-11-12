module.exports.prepare_oanda_input = (args) => {
  args = format_granularity(args)
  args = format_asset_pair(args)
  args = format_columns(args)
  
  return args
}

function format_granularity(args) {
  let formated_granularity = ''
  const granularity = args['granularity']
  if (granularity >= 5 && granularity < 60) {
    formated_granularity = 'S5'
  } else if (granularity >= 60 && granularity < 3600) {
    formated_granularity = 'M1'
  } else if (granularity >= 3600 && granularity < 86400) {
    formated_granularity = 'H1'
  } else if (granularity >= 86400) {
    formated_granularity = 'D'
  }
  args['granularity'] = formated_granularity;

  return args
}


function format_columns(args) {
  if(args['columns'] == null) return args;

  const columns = args['columns']
  const index = columns.indexOf('datetime')
  if (index != -1) columns[index] = 'date'
  args['columns'] = columns
  
  return args
}


function format_asset_pair(args) {
  let asset_pair = args['asset']
  asset_pair = asset_pair.replace('/', '_')
  args['asset'] = asset_pair

  return args
}