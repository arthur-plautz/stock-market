source .env
eval $(minikube docker-env)

export KUBECONFIG=$HOME/.kube/stock_market_config

export TF_VAR_docker_host=$DOCKER_HOST
export TF_VAR_kube_config=$KUBECONFIG