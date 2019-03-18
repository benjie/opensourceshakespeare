/*
 * Before enabling LDS, configure PostgreSQL as shown here:
 *
 * https://www.npmjs.com/package/@graphile/lds#postgresql-configuration
 */
const ENABLE_LDS = false;

module.exports = {
  options: {
    connection: "sampledb",
    schema: ["shakespeare"],
    graphiqlRoute: '/',
    enhanceGraphiql: true,
    subscriptions: true,
    simpleSubscription: false,
    live: ENABLE_LDS,
    plugins: [
      "@graphile/pg-pubsub"
    ],
    appendPlugins: [
      ENABLE_LDS ? "@graphile/subscriptions-lds" : null,
      "@graphile-contrib/pg-simplify-inflector",
      "postgraphile-plugin-connection-filter"
    ].filter(_ => _)
  }
};

