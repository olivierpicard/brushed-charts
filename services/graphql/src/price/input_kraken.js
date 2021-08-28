module.exports.prepare_kraken_input = (args) => {
  args = format_granularity(args)

  return args
}


function format_granularity(args) {
  let formated_granularity = 0
  const granularity = args['granularity']

  if (granularity >= 60 && granularity < 3600) {
    formated_granularity = 1
  } else if (granularity >= 3600 && granularity < 86400) {
    formated_granularity = 60
  } else if (granularity >= 86400) {
    formated_granularity = 1440
  }
  args['granularity'] = formated_granularity;

  return args
}