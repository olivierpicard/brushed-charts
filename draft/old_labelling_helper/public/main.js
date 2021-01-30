import { GraphQL } from "./graphql.js";
import { Chart } from './chart.js'

class Main {
  constructor() {
    this.chart = new Chart()
    GraphQL.GetCandles({
      dateFrom: "2021-01-28 10:00:00",
      dateTo: "2021-01-28 10:01:00",
      instrument: "EUR_USD",
      granularity: "S5"
    }).then((result) => this.handleCandleResult(result)).catch( reason => console.log(reason))
  }


  async handleCandleResult(result) {
    const formattedCandles = this.formatCandleForChart(result)
    this.chart.addCandlestick(formattedCandles)
  }


  formatCandleForChart(rawCandles) {
    const candleType = 'mid'
    var formattedCandles = []

    rawCandles.forEach(elem => {
      let candle = {}
      candle['time'] = Date.parse(elem['date']) / 1000
      candle['open'] = elem[candleType]['open']
      candle['high'] = elem[candleType]['high']
      candle['low'] = elem[candleType]['low']
      candle['close'] = elem[candleType]['close']
      formattedCandles.push(candle)
    });

    return formattedCandles;
  }
}

new Main()