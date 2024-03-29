module.exports.prepare_oanda_output = (result) => {
  for (var i = 0; i < result.length; i++) {
    var row = result[i];
    parse_datetime(row);
    create_price_column(row);
    add_field_spread(row);
    parse_granularity(row);
    rename_volume_to_trade_count(row)
    rename_instrument_to_asset(row)
    add_field_uniform_volume(row)
  }

  return result;
}


function parse_datetime(row) {
  let datetime_str = row['date']['value'];
  row['datetime'] = new String(datetime_str);
  delete row['date']
}


function create_price_column(row) {
  row['price'] = row['mid'];
}


function add_field_spread(row) {
  const spread = row['ask']['close'] - row['bid']['close'];
  row['spread'] = spread;
}


function parse_granularity(row) {
  const granularity_minute = row['granularity'];
  format_gran = 0;
  switch (granularity_minute) {
    case 'S5':
      format_gran = 5;
      break;
    case 'M1':
      format_gran = 60;
      break;
    case 'H1':
      format_gran = 60 * 60;
      break;
    case 'D':
      format_gran = 60 * 60 * 24;
      break;
  }

  row['granularity'] = format_gran;
}


function rename_volume_to_trade_count(row) {
  row['trade_count'] = row['volume']
  delete row['volume']
}


function rename_instrument_to_asset(row) {
  let instrument = row['instrument']
  instrument = instrument.replace('_', '/')
  row['asset'] = instrument
}

function add_field_uniform_volume(row) {
  row['uniform_volume'] = row['trade_count']
}