const { prepare_kraken_output: prepare_kraken_ouput } = require("./output_kraken");
const { prepare_oanda_output: prepare_oanda_ouput } = require("./output_oanda");

module.exports.prepare_ouput = (source, rows) => {
  output = null;
  switch (source) {
    case 'oanda':
      output = prepare_oanda_ouput(rows)
      break;
    case 'kraken':
      output = prepare_kraken_ouput(rows)
      break;
  }

  console.log(output)
  return output;
}