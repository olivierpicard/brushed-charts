import { useQuery, gql } from '@apollo/client';


const query = gql` 
query(
  $dateFrom: String!,
  $dateTo: String!,
  $instrument: String!,
  $granularity: String!) 
{ 
  getCandles(
    dateFrom: $dateFrom,
    dateTo: $dateTo,
    instrument: $instrument,
    granularity: $granularity) 
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
`


export function GetCandleGraphql({variables}) {
  const { loading, error, data } = useQuery(query, {
    variables: { variables },
  });


  const result =  data.getCandles
  console.log(result);

  return result
}
    
    // export class GetCandle {
    //   static makeRequest(body) {
    //     return {
    //       method: "post",
    //       headers: {
    //         "Content-Type": "application/json"
    //       },
    //       body: body
    //     };
    //   }
    
    //   static async GetCandles(candlesVariables) {
    //     const url = 'http://localhost:3330/graphql'
    //     const jsonVariables = JSON.stringify(candlesVariables)
    //     const graphqlQuery = JSON.stringify({
    //       query: query,
    //       variables: jsonVariables
    //     })
    //     const request = GraphQL.makeRequest(graphqlQuery)
    //     var jsonResult
    //     try {
    //       const resp = await fetch(url, request);
    //       jsonResult = await resp.json()  
    
    //     } catch (error) {
    //       console.log('errro:' + error)
    //     }
    
    //     const candles = jsonResult['data']['getCandles']
    
    //     return candles
    //   }
    // }
    
    // export default GraphQL
