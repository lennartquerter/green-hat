import fetch from 'node-fetch';
const express = require('express');
const { BigQuery } = require('@google-cloud/bigquery');
const app = express();
const bigquery = new BigQuery();

app.post('/map-to-osm-way', async (req, res) => {
    console.log('Received request', req.body);
});

async function fetchData(lat, lon) {
    const url = `https://nominatim.openstreetmap.org/reverse.php?lat=${lat}&lon=${lon}&zoom=16&format=jsonv2`;

    try {
        const response = await fetch(url);
        const body = await response.json();
        return body.osm_id;
    } catch (error) {
        console.error(error);
        return null;  // Return null or some error value when there's an exception
    }
}

app.listen(8000, () => {
    console.log('Server running on port 8000');
});
