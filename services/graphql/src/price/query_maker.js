var dateFrom, dateTo, granularity, asset, source, mode, columns


module.exports.query_maker = (args) => {
  assign_args_to_vars(args)
  query = query_maker_dispatch(source)
  options = add_options(query)
  return options
}



function assign_args_to_vars(args) {
  dateFrom = args['dateFrom']
  dateTo = args['dateTo']
  granularity = args['granularity']
  asset = args['asset']
  source = args['source'] // e.g: brushed-charts.prod.kraken
  columns = get_columns(args)
  // mode = args['mode'] // e.g: dev | test | prod
}

function get_columns(args) {
  if (args['columns'] == undefined) {
    return '*';
  }
  return args['columns'].join()
}

function query_maker_dispatch(source) {
  query = null;
  switch (source) {
    case 'oanda':
      query = make_oanda_query();
      break
    case 'kraken':
      query = make_kraken_query();
      break
  }

  return query;
}

function make_oanda_query() {
  tablename = 'brushed-charts.prod.oanda_prices'

  const query = `
  SELECT
    ${columns},
    UNIX_SECONDS(TIMESTAMP(date)) AS timestamp
  FROM \`${tablename}\` 
  WHERE 
    granularity = "${granularity}" AND 
    instrument = "${asset}" AND 
    date >= "${dateFrom}" AND date < "${dateTo}"
  ORDER BY date DESC
  `
  return query
}


function make_kraken_query() {
  tablename = 'brushed-charts.prod.kraken_ohlc'

  const query = `
  SELECT
    ${columns},
    UNIX_SECONDS(TIMESTAMP(datetime)) AS timestamp
  FROM \`${tablename}\` 
  WHERE 
    granularity = ${granularity} AND 
    asset_pair = "${asset}" AND 
    datetime >= "${dateFrom}" AND datetime < "${dateTo}"
    ORDER BY datetime DESC
  `

  return query
}


function add_options(query) {
  return {
    query: query,
    location: 'EU'
  };
}