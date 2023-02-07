from airflow.models import Variable

API_KEY = Variable.get('api_key', default_var=None)
TICKER = Variable.get('ticker', default_var=None)
DATALAKE = Variable.get('datalake', default_var='/src/data')