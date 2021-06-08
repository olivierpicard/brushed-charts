import { createChart, IChartApi, ISeriesApi, SeriesOptionsMap } from 'lightweight-charts';

class View {
    chart: IChartApi
    div_chart: HTMLElement
    price: ISeriesApi<any>;

    constructor() {
        this.div_chart = document.getElementById('chart')
        this.chart = createChart(this.div_chart, { width: 300, height: 400 });
        this.handle_resize()
        window.onresize = () => this.handle_resize();
    }

    
    handle_resize() {
        let height = this.div_chart.offsetHeight;
        let width = this.div_chart.offsetWidth;
        this.chart.resize(width, height);
    }

}