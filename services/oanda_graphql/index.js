const { ApolloServer, gql } = require('apollo-server');
const { resolvers } = require('./resolvers');
const { typeDefs } = require('./typeDefs');
const { getBigqueryCandles } = require('./bigquery_get_candles');

// var args = []
// args['dateFrom'] = new Date(Date.parse("2020-12-28T00:00:00.0000Z"))
// args['dateTo'] = new Date(Date.parse("2021-01-02T00:00:00.0000Z"))
// args['instrument'] = 'EUR_USD'
// args['granularity'] = 'S5'

// getBigqueryCandles(args)


const server = new ApolloServer({ typeDefs, resolvers });

server.listen(3000).then(({ url }) => {
  console.log(`Server ready at ${url}`);
});