const { prepare_kraken_input } = require("./input_kraken");
const { prepare_oanda_input } = require("./input_oanda");

module.exports.prepare_input = (args) => {
  input = null;
  source = args['source']
  
  switch (source) {
    case 'oanda':
      input = prepare_oanda_input(args)
      break;
    case 'kraken':
      input = prepare_kraken_input(args)
      break;
  }
      
  return input;
}