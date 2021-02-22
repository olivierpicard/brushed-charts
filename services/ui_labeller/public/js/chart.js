export class Chart {
  chartContainerID = "chartContainer"

  constructor() {
    this.chartContainer = document.getElementById(this.chartContainerID)
    this.chart = LightweightCharts.createChart(
      this.chartContainer, this.getContainerSize()
    )

    window.onresize = () => this.onResize()
  }

  getContainerSize() {
    return {
      width: this.chartContainer.clientWidth,
      height: this.chartContainer.clientHeight
    }
  }

  onResize() {
    const containerSize = this.getContainerSize();
    this.chart.resize(containerSize.width, containerSize.height)
  }

}