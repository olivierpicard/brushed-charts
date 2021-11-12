const { gql } = require('apollo-server');

// A schema is a collection of type definitions (hence "typeDefs")
// that together define the "shape" of queries that are executed against
// your data.
module.exports.typeDefs = gql`
  type OHLC {
    open: Float!
    high: Float!
    low: Float!
    close: Float!
  }

  type Candlestick {
    asset: String!
    datetime: String!
    timestamp: Float!
    granularity: Int!
    price: OHLC!
    spread: OHLC
    trade_count: Int
    volume: Float
    uniform_volume: Float
    vwap: Float
  }

  input SourceSelector{
    dateFrom: String!
    dateTo: String!
    asset: String!
    granularity: Int!
    source: String!
  }

  type Point{
    datetime: String!
    timestamp: Float!
    value: Float!
  }

  
  type Query {
    ping: String!
    
    ohlc_price(
      sourceSelector: SourceSelector!
    ): [Candlestick!]!

    moving_average(
      sourceSelector: SourceSelector!
      windowSize: Int!
      ohlcAttribute: String
    ): [Point!]!
  }
`;