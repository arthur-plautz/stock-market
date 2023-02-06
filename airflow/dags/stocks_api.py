from datetime import datetime
import logging
from definitions import API_KEY, TICKER, DATALAKE

from airflow.decorators import dag, task

@dag(schedule='@daily', start_date=datetime(2022, 2, 4), catchup=False)
def stocks_api():

    @task(retries=2)
    def extract(**kwargs):
        from polygon import RESTClient
        from polygon.exceptions import NoResultsError
        import pandas as pd

        client = RESTClient(api_key=API_KEY)
        ds = kwargs.get('ds')
        next_ds = kwargs.get('next_ds')

        try:
            bars = client.get_aggs(
                ticker=TICKER,
                multiplier=1,
                timespan="minute",
                from_=ds,
                to=next_ds
            )
        except NoResultsError:
            logging.info("\n[Empty Results]\n")
            return True

        file_path = f"{DATALAKE}/b{ds.replace('-','')}.csv"
        data = pd.DataFrame([bar.__dict__ for bar in bars])
        data.to_csv(file_path, index=False)

    extract()

dag = stocks_api()
