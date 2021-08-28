module.exports.prepare_oanda_output = (result) => {
  for (var i = 0; i < result.length; i++) {
    var row = result[i];
    parse_datetime(row);
  }

  return result;
}


function parse_datetime(row) {
  let datetime_str = row['date']['value'];
  row['datetime'] = new String(datetime_str);
  delete row['date']
}
