const express = require('express');
const { BigQuery } = require('@google-cloud/bigquery');
const app = express();
const bigquery = new BigQuery();

app.get('/query_data', async (req, res) => {
    const query = `
        SELECT road_id, osm_fclass, AVG(no2_ppb) as avg_no2_ppb, AVG(co2_ppm) as avg_co2_ppm
        FROM 'road_config.road_config'
        WHERE osm_fclass = 'service'
        GROUP BY road_id, osm_fclass
        ORDER BY avg_no2_ppb DESC
        LIMIT 10;
    `;

    const options = {
        query: query,
        location: 'US',
    };

    try {
        const [rows] = await bigquery.query(options);
        res.send(rows);
    } catch (error) {
        console.error('ERROR:', error);
        res.status(500).send('Failed to query BigQuery');
    }
});

app.listen(8000, () => {
    console.log('Server running on port 8000');
});
