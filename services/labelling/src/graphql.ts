import { gql, useQuery } from '@apollo/client'

export function load() {
    let variables = {
        dateFrom: "2021-06-28 10:00:00",
        dateTo: "2021-06-20 10:01:00",
        instrument: "EUR_USD",
        granularity: "S5"
    }

    let query = `
    {
        query(
            $dateFrom: String!,
            $dateTo: String!,
            $instrument: String!,
            $granularity: String!,
            $source: String!
        ){
          getCandles(
            dateFrom: $dateFrom,
            dateTo: $dateTo,
            instrument: $instrument,
            granularity: $granularity
            source: $source
          ){
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
    }
`;

fetch('http://194.163.138.132:3330/graphql', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: JSON.stringify({
      query,
      variables: variables,
    })
  }).then(r => r.json())
    .then(data => console.log('data returned:', data));
}