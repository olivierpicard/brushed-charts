const { ApolloServer, gql } = require('apollo-server');
const { resolvers } = require('./resolvers');
const { typeDefs } = require('./typeDefs');
const { getBigqueryCandles } = require('./bigquery_get_candles');

const server = new ApolloServer({ typeDefs, resolvers });

server.listen(3330).then(({ url }) => {
  console.log(`Server ready at ${url}`);
});