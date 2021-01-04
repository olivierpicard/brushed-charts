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
    instrument: String!
    date: String!
    granularity: String!
    bid: Candlestick!
    ask: Candlestick!
    mid: Candlestick!
    spread: Candlestick!
    volume: Int!
  }
  
  type Query {
    getCandles(dateFrom: String, dateTo: String, instrument: String, granularity: String): [CandlesMetadata!]!
  }
`;