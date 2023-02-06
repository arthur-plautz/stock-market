source config.sh

cd ..
minikube start --mount --mount-string="$(pwd):/src" --memory $CLUSTER_MEMORY --cpus $CLUSTER_CPUS