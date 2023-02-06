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

provider "docker" {
  host = var.docker_host
}

provider "kubernetes" {
  config_path    = var.kube_config
}

provider "helm" {
  kubernetes {
    config_path    = var.kube_config
  }
}