const { prepare_oanda_input } = require("./input_oanda");

module.exports.prepare_input = (args) => {
  input = args;
  // source_args = args['sourceSelector'];
  source = args['source']
  
  switch (source) {
    case 'oanda':
      input = prepare_oanda_input(args)
      break;
  }
      
  return input;
}