const { prepare_input } = require("./prepare_input")
const { prepare_ouput } = require("./prepare_output")

var dateFrom, dateTo, granularity, asset_pair, source, mode


module.exports.query_maker = (args) => {
  assign_args_to_vars(args)
  args = prepare_input(args)
  query = query_maker_dispatch(source)
  options = add_options(query)
  
  return options
}


function assign_args_to_vars(args) {
  dateFrom = args['dateFrom']
  dateTo = args['dateTo']
  granularity = args['granularity']
  asset_pair = args['instrument']
  source = args['source'] // e.g: brushed-charts.prod.kraken
  mode = args['mode'] // e.g: dev | test | prod
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
  SELECT * 
  FROM \`${tablename}\` 
  WHERE 
    granularity = "${granularity}" AND 
    instrument = "${asset_pair}" AND 
    date >= "${dateFrom}" AND date < "${dateTo}"
  `
  return query
}


function make_kraken_query() {
  tablename = 'brushed-charts.prod.kraken_ohlc'

  const query = `
  SELECT * 
  FROM \`${tablename}\` 
  WHERE 
    granularity = ${granularity} AND 
    asset_pair = "${asset_pair}" AND 
    datetime >= "${dateFrom}" AND datetime < "${dateTo}"
  `

  return query
}


function add_options(query) {
  return {
    query: query,
    location: 'EU'
  };
}