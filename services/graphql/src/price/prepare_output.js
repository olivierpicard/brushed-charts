const { prepare_kraken_output } = require("./output_kraken");
const { prepare_oanda_output } = require("./output_oanda");

module.exports.prepare_ouput = (source, rows) => {
  output = null;
  switch (source) {
    case 'oanda':
      output = prepare_oanda_output(rows)
      break;
    case 'kraken':
      output = prepare_kraken_output(rows)
      break;
  }

  return output;
}