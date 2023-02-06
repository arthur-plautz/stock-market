from datetime import datetime
from definitions import API_KEY, TICKER, DATALAKE
from airflow.decorators import dag, task
from airflow.providers.postgres.operators.postgres import PostgresOperator


def clean_ds(ds):
    return ds.replace('-','')

def datalake_path(ds):
    return f"{DATALAKE}/raw/incremental/b{clean_ds(ds)}.csv"

@dag(schedule='0 23 * * 1-5', start_date=datetime(2023, 2, 1), catchup=True)
def stocks_api_incremental():

    @task(retries=2)
    def extract(**kwargs):
        from polygon import RESTClient
        import pandas as pd

        client = RESTClient(api_key=API_KEY)
        ds = kwargs.get('ds')
        next_ds = kwargs.get('next_ds')

        bars = client.get_aggs(
            ticker=TICKER,
            multiplier=1,
            timespan="minute",
            from_=ds,
            to=next_ds
        )

        file_path = datalake_path(ds)
        data = pd.DataFrame([bar.__dict__ for bar in bars])
        data.to_csv(file_path, index=False)

    def load():
        ds = f"{{{{ds_nodash}}}}"
        file_path = datalake_path(clean_ds(ds))
        ticker = str(TICKER).lower()
        temp_table = f"{ticker}{ds}"
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

dag = stocks_api_incremental()
