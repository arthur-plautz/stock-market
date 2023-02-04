terraform {
  backend "local" {
    path = "../.states/airflow/terraform.tfstate"
  }

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.1"
    }
  }

  required_version = "~> 1.2.0"
}

data "local_file" "docker_host" {
  filename = "../.dockerhost"
}

provider "docker" {
  host = data.local_file.docker_host.content
}

provider "kubernetes" {
  config_path    = "~/.kube/stock_market_config"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/stock_market_config"
  }
}