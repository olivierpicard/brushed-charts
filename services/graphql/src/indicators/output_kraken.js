module.exports.prepare_kraken_output = (result) => {
  for (var i = 0; i < result.length; i++) {
    var row = result[i]
    parse_datetime(row)
  }
  
  return result
}


function parse_datetime(row) {
  let datetime_str = row['datetime']['value']
  row['datetime'] = datetime_str
}