source .env
export KUBECONFIG=$HOME/.kube/stock_market_config

cd ..
minikube start --mount --mount-string="$(pwd)/airflow/dags:/src/dags"