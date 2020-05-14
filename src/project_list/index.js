const { Client } = require('pg')
const SQL = require('sql-template-strings')

exports.handler = async (event) => {
  const origin = event.headers.origin || event.header.origin;
  const allowedOrigin = event.stageVariables.allowed_origin;
  if (allowedOrigin.indexOf(origin) === -1) return { statusCode: 204 }
  const client = new Client()
  await client.connect()
  // const params = JSON.parse(event.body)
  const sql = SQL`SELECT name from project`
  console.log(sql)
  const { rows } = await client.query(sql)

  const response = {
    statusCode: 200,
    body: JSON.stringify(rows.map(row => row.name)),
    headers: {
      "Access-Control-Allow-Origin": origin
    },
  };
  return response;
};

