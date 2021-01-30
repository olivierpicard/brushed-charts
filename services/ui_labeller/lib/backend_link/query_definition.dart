library brushed_charts_graphql;

const query_get_candles = '''
query(
  \$dateFrom: String!,
  \$dateTo: String!,
  \$instrument: String!,
  \$granularity: String!)
  {
    getCandles(
    dateFrom: \$dateFrom,
    dateTo: \$dateTo,
    instrument: \$instrument,
    granularity: \$granularity)
    {
      date
      volume
      mid {
        open
        high
        low
        close
      }
    }
  }
''';
