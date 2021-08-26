module.exports.prepare_kraken_input = (args) => {
  args = format_granularity(args)

  return args
}


function format_granularity(args) {
  granularity = args['granularity']
  granularity = Math.round(granularity / 60)
  args['granularity'] = granularity

  return args
}