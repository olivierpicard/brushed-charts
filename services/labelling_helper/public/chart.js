export class Chart {
  chart = null;
  constructor() {
    this.chart = LightweightCharts.createChart(document.body, {
      width: 400,
      height: 300,
      timeScale: {
        timeVisible: true,
        secondsVisible: true,
      }
    });
    this.handleResize();
    window.onresize = () => this.handleResize();
    this.addCandlestickSeries(null)
  }
  
  handleResize() {
    const width = window.innerWidth;
    const height = window.innerHeight;
    this.chart.resize(width, height);
  }
  
  addCandlestickSeries(listOfCandle) {
    // console.log(listOfCandle)
    // const candlestickSeries = this.chart.addCandlestickSeries();
    // candlestickSeries.setData(listOfCandle)
    const lineSeries = this.chart.addLineSeries();
    lineSeries.setData([
    { time: 1611136800, value: 80.01 },
    { time: 1611136805, value: 96.63 },
    { time: 1611136810, value: 76.64 },
    { time: 1611136815, value: 81.89 },
    { time: 1611136820, value: 74.43 },
    { time: 1611136825, value: 80.01 },
    { time: 1611136830, value: 96.63 },
    { time: 1611136835, value: 76.64 },
    { time: 1611136840, value: 81.89 },
    { time: 1611136845, value: 74.43 },
]);

    return candlestickSeries
  }
}



