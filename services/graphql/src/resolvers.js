const { getCandles } = require('./price/get_candles')
const { moving_average } = require('./indicators/moving_average')

module.exports.resolvers = {
  Query: {
    ohlc_price: (parent, args, context, info) => getCandles(args),
    moving_average: (parent, args, context, info) => moving_average(args),
    ping: (parent, args, context, info) => "pong",
  },
};
   