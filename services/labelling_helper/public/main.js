import { GraphQL } from "./graphql.js";
import { Chart } from './chart.js'

class Main {
  constructor() {
    this.chart = new Chart()
    GraphQL.GetCandles({
      dateFrom: "2021-01-20 10:00:00",
      dateTo: "2021-01-20 10:07:00",
      instrument: "EUR_USD",
      granularity: "S5"
    }).then((result) => this.handleCandleResult(result))
  }


  handleCandleResult(result) {
    const formattedCandles = this.formatCandleForChart(result)
    this.chart.addCandlestickSeries(formattedCandles)
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