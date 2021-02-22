import { QUERY_GET_CANDLES } from "./graphql_query.js";
const GRAPHQL_URL = "http://localhost:3330/graphql";

class PrivateFetcher {
  static makeHeader() {
    return {
      "url": GRAPHQL_URL,
      "method": "POST",
      "timeout": 0,
      "headers": {
        "Content-Type": "application/json"
      }
    }
  }
}

export class Fetcher {
  static async GetCandle(dateFrom, dateTo, instrument, granularity) {
    var request = PrivateFetcher.makeHeader()
    
    request['data'] = JSON.stringify({
      query: QUERY_GET_CANDLES,
      variables: {
        "dateFrom": dateFrom,
        "dateTo": dateTo,
        "instrument": instrument,
        "granularity": granularity
      }
    })
    
    const response = await $.ajax(request)
    return response
  }


  
}