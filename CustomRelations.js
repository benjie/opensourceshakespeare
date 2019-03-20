const { makeExtendSchemaPlugin, gql, embed } = require("graphile-utils");

module.exports = makeExtendSchemaPlugin(build => {
  const { pgSql: sql } = build;
  return {
    typeDefs: gql`
      extend type Character {
        works: WorksConnection @pgQuery(
          source: ${embed(sql.fragment`shakespeare.work`)}
          withQueryBuilder: ${embed(queryBuilder => {
            queryBuilder.where(sql.fragment`exists(
              select 1
              from shakespeare.character_work
              where character_work.work_id = ${queryBuilder.getTableAlias()}.id
              and character_work.character_id = ${queryBuilder.parentQueryBuilder.getTableAlias()}.id
            )`);
          })}
        )
      }
    `
  };
});
