import { Chart } from "./chart.js";
import { Fetcher } from "./fetcher.js";

class Main {
  constructor() {
    this.chart = new Chart()
    Fetcher.GetCandle("2021-02-22 10:00:00", "2021-02-22 10:01:00", "EUR_USD", "S5")
  }
}

$(document).ready(() => {
  new Main()
})
