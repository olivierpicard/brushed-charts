const { getCandles } = require('./get_candles')

module.exports.resolvers = {
  Query: {
    getCandles: (parent, args, context, info) => getCandles(args),
  },
};
   