const { BigQuery, BigQueryTimestamp } = require('@google-cloud/bigquery');
const { GraphQLScalarType, parseType, Kind } = require('graphql');
const { getBigqueryCandles } = require('./bigquery_get_candles')

module.exports.resolvers = {
  Query: {
    getCandles: (parent, args, context, info) => getBigqueryCandles(args),
  },
};
