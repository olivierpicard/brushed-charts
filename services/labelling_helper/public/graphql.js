const query = "query(\n    $dateFrom: String!,\n    $dateTo: String!,\n    $instrument: String!,\n    $granularity: String!\n){\n  getCandles(\n    dateFrom: $dateFrom,\n    dateTo: $dateTo,\n    instrument: $instrument,\n    granularity: $granularity\n  ){\n    date\n    volume\n    mid {\n        open\n        high\n        low\n        close\n    }\n  }\n}"

export class GraphQL {
  static makeRequest(body) {
    return {
      method: "post",
      headers: {
        "Content-Type": "application/json"
      },
      body: body
    };
  }
  
  static async GetCandles(candlesVariables) {
    const url = 'http://localhost:3330/graphql'
    const jsonVariables = JSON.stringify(candlesVariables)
    const graphqlQuery = JSON.stringify({
      query: query,
      variables: jsonVariables
    })
    const request = GraphQL.makeRequest(graphqlQuery)
    var jsonResult
    try {
      const resp = await fetch(url, request);
      jsonResult = await resp.json()  
    } catch (error) {
      console.error('errro:' + error)
    }
    
    const candles = jsonResult['data']['getCandles']
    
    return candles
  }
}
