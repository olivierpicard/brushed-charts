module.exports.flat_source = (args, attrName) => {
  const source = args[attrName]
  for (const key in source) {
    args[key] = source[key];
  }
  delete args[attrName]
  return args;
}