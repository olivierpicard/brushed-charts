module.exports.prepare_kraken_output = (result) => {
  for (var i = 0; i < result.length; i++) {
    var row = result[i]
    parse_datetime(row)
    parse_granularity(row)
    make_parse(row)
  }
  
  return result
}


function parse_datetime(row) {
  let datetime_str = row['datetime']['value']
  row['datetime'] = datetime_str
}


function parse_granularity(row) {
  const granularity_minute = row['granularity']
  granularity_second = granularity_minute * 60
  row['granularity'] = granularity_second
}


function make_parse(row) {
  const candle = {
    open: row['open'],
    high: row['high'],
    low: row['low'],
    close: row['close']
  }

  row['price'] = candle
}