module.exports.prepare_oanda_input = (args) => {
  args = format_asset_pair(args)
  args = format_columns(args)
  
  return args
}


function format_asset_pair(args) {
  let asset_pair = args['asset']
  asset_pair = asset_pair.replace('/', '_')
  args['asset'] = asset_pair
  
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