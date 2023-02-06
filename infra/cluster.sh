source config.sh

cd ..
minikube start --mount --mount-string="$(pwd):/src"