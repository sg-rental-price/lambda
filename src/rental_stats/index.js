const { Client } = require('pg')
const SQL = require('sql-template-strings')

exports.handler = async (event) => {
  const client = new Client()
  await client.connect()
  const params = JSON.parse(event.body)
  const sql = SQL`SELECT
    count(*),
    min(rental.rent),
    percentile_disc(0.25) within group(order by rental.rent) as low,
    percentile_disc(0.5) within group(order by rental.rent) as median,
    percentile_disc(0.75) within group(order by rental.rent) as high,
    max(rental.rent)
  FROM rental`
  const where = SQL` WHERE 1=1`
  const { project, areaSqm, leaseDate, bedRoom } = params
  if (project) {
    sql.append(` LEFT JOIN project on project.id = rental.project_id`)
    where.append(SQL` AND project.name = ANY(${project})`)
  }
  if (areaSqm) {
    const val = `[${areaSqm.join(',')}]`
    where.append(SQL` AND rental.area_sqm @> ${val}`)
  }
  if (leaseDate) {
    where.append(SQL` AND rental.lease_date >= ${leaseDate[0]} AND rental.lease_date <= ${leaseDate[1]}`)
  }
  if (bedRoom) {
    where.append(SQL` AND rental.bedroom_no = ANY(${bedRoom})`)
  }
  if (where.strings.length > 1) {
    sql.append(where)
  }
  console.log(sql)
  const { rows } = await client.query(sql)

  const response = {
    statusCode: 200,
    body: JSON.stringify(rows[0]),
    headers: {
      "Access-Control-Allow-Origin": "http://sgrentalprice.s3-website-ap-southeast-1.amazonaws.com"
    },
  };
  return response;
};

