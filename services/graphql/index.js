const express = require('express')
const { ApolloServer } = require('apollo-server-express');
const { resolvers } = require('./resolvers');
const { typeDefs } = require('./typeDefs');

const app = express();
const server = new ApolloServer({ typeDefs, resolvers });
server.applyMiddleware({ app, path: '/' });

app.listen({port: 3330}, () => 
  console.log(`Server ready at port 3330`)
);