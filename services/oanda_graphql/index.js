const { ApolloServer, gql } = require('apollo-server');
const { resolvers } = require('./resolvers');
const { typeDefs } = require('./typeDefs');
const { getBigqueryCandles } = require('./bigquery_get_candles');

const PORT = process.env['OANDA_GRAPHQL_PORT']
const server = new ApolloServer({ typeDefs, resolvers });

server.listen(PORT).then(({ url }) => {
  console.log(`Server ready at ${url}`);
});