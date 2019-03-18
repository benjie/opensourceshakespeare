/*
 * Before enabling LDS, configure PostgreSQL as shown here:
 *
 * https://www.npmjs.com/package/@graphile/lds#postgresql-configuration
 */
const ENABLE_LDS = false;

module.exports = {
  options: {
    // Server plugins
    plugins: [
      "@graphile/pg-pubsub"
    ],

    // Schema plugins
    appendPlugins: [
      ENABLE_LDS ? "@graphile/subscriptions-lds" : null,
      "@graphile-contrib/pg-simplify-inflector",
      "postgraphile-plugin-connection-filter"
    ].filter(_ => _),

    // Database
    connection: process.env.DATABASE_URL || "sampledb",
    schema: ["shakespeare"],

    // GraphiQL
    graphiqlRoute: '/',
    enhanceGraphiql: true,

    // Realtime
    subscriptions: true,
    simpleSubscription: false,
    live: ENABLE_LDS,

    // GraphQL schema config
    simpleCollections: 'both',
    dynamicJson: true,
  }
};

