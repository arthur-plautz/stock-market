from datetime import datetime
from distutils.command.clean import clean
import logging
from definitions import API_KEY, TICKER, DATALAKE
from airflow.decorators import dag, task
from airflow.providers.postgres.operators.postgres import PostgresOperator

def clean_ds(ds):
    return ds.replace('-','')

def datalake_path(ds):
    return f"{DATALAKE}/raw/snapshot/b{ds}.csv"

@dag(schedule='@monthly', concurrency=5, start_date=datetime(2021, 3, 4), end_date=datetime(2023, 2, 4), catchup=True)
def stocks_api_snapshot():
    @task(retries=2)
    def extract(**kwargs):
        from polygon import RESTClient
        import pandas as pd

        client = RESTClient(api_key=API_KEY)
        ds = kwargs.get('ds')
        next_ds = kwargs.get('next_ds')

        logging.info(f"Extracting data from {ds} to {next_ds}...")
        bars = client.get_aggs(
            ticker=TICKER,
            multiplier=1,
            timespan="minute",
            from_=ds,
            to=next_ds
        )

        file_path = datalake_path(clean_ds(ds))
        data = pd.DataFrame([bar.__dict__ for bar in bars])
        data.to_csv(file_path, index=False)
        logging.info(f"Done. Total Rows: {len(bars)}")

    def load():
        ds = f"{{{{ds_nodash}}}}"
        file_path = datalake_path(ds)
        ticker = str(TICKER).lower()
        temp_table = f"{ticker}_{ds}"
        return PostgresOperator(
            task_id="load",
            postgres_conn_id="database",
            sql=f"""
                CREATE TABLE {temp_table} AS TABLE {ticker} WITH NO DATA;
                COPY {temp_table} FROM '{file_path}' DELIMITER ',' CSV HEADER;
                INSERT INTO {ticker} SELECT * FROM {temp_table};
                TRUNCATE TABLE {temp_table};
                DROP TABLE {temp_table};
            """
        )

    extract_task = extract()
    load_task = load()
    extract_task >> load_task

dag = stocks_api_snapshot()
