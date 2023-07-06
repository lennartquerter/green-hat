from google.cloud import bigquery, aiplatform

PROJECT_ID='qwiklabs-gcp-03-8a82d5a047b0'

bqclient = bigquery.Client(project=PROJECT_ID)

sql = """
SELECT road_id, EXTRACT(HOUR FROM timestamp) as dte, AVG(weighted_co2e) as avg_weighted_co2e
FROM `qwiklabs-gcp-03-8a82d5a047b0.table_join.route_live_timestamps_final_v1`
WHERE timestamp is not null
GROUP BY dte, road_id
ORDER BY dte;
"""
dataframe = bqclient.query(sql).to_dataframe()
print(dataframe.head())



def create_bigquery_dataset(dataset_id):
    dataset = bigquery.Dataset(
        bigquery.dataset.DatasetReference(PROJECT_ID, dataset_id)
    )
    dataset.location = "europe-west1"

    try:
        dataset = bqclient.create_dataset(dataset)  # API request
        return True
    except Exception as err:
        print(err)
        if err.code != 409:  # http_client.CONFLICT
            raise
    return False



new_dataset_id = "data_frames"
new_table_id = "weighted_co2e"
dataset_id_full = f"{PROJECT_ID}.{new_dataset_id}"

create_bigquery_dataset(new_dataset_id)
dataset = bigquery.Dataset(dataset_id_full)
table = dataset.table(new_table_id)

job_config = bigquery.LoadJobConfig(
    # Specify a (partial) schema. All columns are always written to the
    # table. The schema is used to assist in data type definitions.
    schema=[
        bigquery.SchemaField("road_id", "INTEGER"),
        bigquery.SchemaField("dte", "DATE"),
        bigquery.SchemaField("avg_weighted_co2e", "FLOAT"),
    ],
    # Optionally, set the write disposition. BigQuery appends loaded rows
    # to an existing table by default, but with WRITE_TRUNCATE write
    # disposition it replaces the table with the loaded data.
    write_disposition="WRITE_TRUNCATE",
)

NEW_BQ_TABLE = f"{dataset_id_full}.{new_table_id}"

job = bqclient.load_table_from_dataframe(
    dataframe, NEW_BQ_TABLE, job_config=job_config
)

job.result()

table = bqclient.get_table(NEW_BQ_TABLE)  # Make an API request.
print(
    "Loaded {} rows and {} columns to {}".format(
        table.num_rows, len(table.schema), NEW_BQ_TABLE
    )
)