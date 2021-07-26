const { ApolloServer } = require('apollo-server');
const { resolvers } = require('./resolvers');
const { typeDefs } = require('./typeDefs');

const server = new ApolloServer({
  cors: {
    origin: '*', credentials: true
  }, typeDefs, resolvers
});

server.listen({ port: 80 }).then(({ url }) => {
  console.log(`Server ready at ${url}`);
});