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
  }
  
  handleResize() {
    const width = window.innerWidth;
    const height = window.innerHeight;
    this.chart.resize(width, height);
  }
  
  addCandlestick(listOfCandle) {
    var arr = []
    const candlestickSeries = this.chart.addCandlestickSeries();
    // listOfCandle.forEach(element => {
    //   var dic = {
    //     'time': element['time'],
    //     'open': element['open'],
    //     'high': element['high'],
    //     'low': element['low'],
    //     'close': element['close']
    //   }
      
    //   arr.push(dic)
    // });
    // candlestickSeries.setData(arr)
    // const lineSeries = this.chart.addLineSeries();
      candlestickSeries.setData([
    { time: 1611136800, open: 54.62, high: 55.5, low: 54.52, close: 54.9 },
    { time: 1611828025, open: 1.21069, high: 1.210705, low: 1.21062, close: 1.21063},
    { time: 1611136900, open: 55.08, high: 55.27, low: 54.61, close: 54.98 },
    { time: 1611137001, open: 56.09, high: 57.47, low: 56.09, close: 57.21 },
    { time: 1611137100, open: 57.0, high: 58.44, low: 56.41, close: 57.42 },
    { time: 1611137200, open: 57.46, high: 57.63, low: 56.17, close: 56.43 },
    { time: 1611137300, open: 56.26, high: 56.62, low: 55.19, close: 55.51 },
    { time: 1611137400, open: 55.81, high: 57.15, low: 55.72, close: 56.48 },
    { time: 1611137500, open: 56.92, high: 58.8, low: 56.92, close: 58.18 },
    { time: 1611137600, open: 58.32, high: 58.32, low: 56.76, close: 57.09 },
    { time: 1611137700, open: 56.98, high: 57.28, low: 55.55, close: 56.05 },
    { time: 1611137800, open: 56.34, high: 57.08, low: 55.92, close: 56.63 },
    { time: 1611137900, open: 56.51, high: 57.45, low: 56.51, close: 57.21 },
    { time: 1611138000, open: 57.02, high: 57.35, low: 56.65, close: 57.21 },
    { time: 1611138100, open: 57.55, high: 57.78, low: 57.03, close: 57.65 },
    { time: 1611138200, open: 57.7, high: 58.44, low: 57.66, close: 58.27 },
    { time: 1611138300, open: 58.32, high: 59.2, low: 57.94, close: 58.46 },
    { time: 1611138400, open: 58.84, high: 59.4, low: 58.54, close: 58.72 },
    { time: 1611138500, open: 59.09, high: 59.14, low: 58.32, close: 58.66 },
    { time: 1611138600, open: 59.13, high: 59.32, low: 58.41, close: 58.94 },
    { time: 1611138700, open: 58.85, high: 59.09, low: 58.45, close: 59.08 },
    { time: 1611138800, open: 59.06, high: 60.39, low: 58.91, close: 60.21 },
    { time: 1611138900, open: 60.25, high: 61.32, low: 60.18, close: 60.62 },
    { time: 1611139000, open: 61.03, high: 61.58, low: 59.17, close: 59.46 },
    { time: 1611139100, open: 59.26, high: 59.9, low: 58.88, close: 59.16 },
    { time: 1611139200, open: 58.86, high: 59.0, low: 58.29, close: 58.64 },
    { time: 1611139300, open: 58.64, high: 59.51, low: 58.31, close: 59.17 },
    { time: 1611139400, open: 59.21, high: 60.7, low: 59.18, close: 60.65 },
    { time: 1611139500, open: 60.7, high: 60.73, low: 59.64, close: 60.06 },
    { time: 1611139600, open: 59.42, high: 59.79, low: 59.26, close: 59.45 },
      ]);
    return candlestickSeries
  }
}



