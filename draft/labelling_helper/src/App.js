import { useRef } from 'react';
import Chart from './Chart'
import { GetCandleGraphql } from './Graphql'

import './styles.css'

function App() {
  const chart = useRef()
  var priceData = []

  const variables = {
    'dateFrom': "2021-01-28 10:00:00",
    'dateTo': "2021-01-28 10:01:00",
    'instrument': "EUR_USD",
    'granularity': "S5",
  }
  
  GetCandleGraphql(variables).then((result)=>console.log("sdsd" + result))

  function handleCandleResult(result) {
    const formattedCandles = formatCandleForChart(result)
    console.log("djksndkjsdn")
  }


  function formatCandleForChart(rawCandles) {
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


  return (
    <Chart chartRef={chart} />
  );
}

export default App;