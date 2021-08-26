const { getCandles } = require('./price/get_candles')

module.exports.resolvers = {
  Query: {
    ohlc_price: (parent, args, context, info) => getCandles(args),
    ping: (parent, args, context, info) => "pong",
  },
};
   