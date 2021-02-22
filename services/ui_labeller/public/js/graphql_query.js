export const QUERY_GET_CANDLES = `
query(
  $dateFrom: String!,
  $dateTo: String!,
  $instrument: String!,
  $granularity: String!
) { 
  getCandles(
    dateFrom: $dateFrom, 
    dateTo: $dateTo,
    instrument: $instrument,
    granularity: $granularity
  ) {
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
`