const { gql } = require('apollo-server');

// A schema is a collection of type definitions (hence "typeDefs")
// that together define the "shape" of queries that are executed against
// your data.
module.exports.typeDefs = gql`
  type Candlestick {
    open: Float!
    high: Float!
    low: Float!
    close: Float!
  }

  type CandlesMetadata {
    asset: String!
    datetime: String!
    timestamp: Float!
    granularity: Int!
    price: Candlestick!
    spread: Candlestick
    trade_count: Int!
    volume: Float
    vwap: Float
  }
  
  type Query {
    ping: String!
    getCandles(
        dateFrom: String,
        dateTo: String,
        asset: String,
        granularity: Int,
        source: String
    ): [CandlesMetadata!]!
  }
`;