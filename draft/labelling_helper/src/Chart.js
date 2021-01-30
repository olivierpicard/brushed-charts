import React, { useEffect, useRef } from 'react';
import { createChart } from 'lightweight-charts';
import { priceData } from './priceData';

function Chart(props) {
  // const chartContainerRef = useRef();
  var chartContainerRef = props.chartRef
  const chart = useRef();
  const resizeObserver = useRef();

  useEffect(() => {
    chart.current = createChart(chartContainerRef.current, {
      width: chartContainerRef.current.clientWidth,
      height: 500,
      timeScale: {
        timeVisible: true,
        secondsVisible: true
      }
    });

    const candleSeries = chart.current.addCandlestickSeries();
    candleSeries.setData(props.priceData);

  }, []);

  // Resize chart on container resizes.
  useEffect(() => {
    resizeObserver.current = new ResizeObserver(entries => {
      const { width, height } = entries[0].contentRect;
      chart.current.applyOptions({ width, height });
      chart.current.timeScale().fitContent();
    });

    resizeObserver.current.observe(chartContainerRef.current);

    return () => resizeObserver.current.disconnect();
  }, []);

  return (
    <div ref={chartContainerRef} className="chart-container" />
  );
}

export default Chart;