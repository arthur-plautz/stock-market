terraform {
  backend "local" {
    path = "../.states/database/terraform.tfstate"
  }

  required_version = "~> 1.2.0"
}

provider "kubernetes" {
  config_path    = var.kube_config
}

provider "helm" {
  kubernetes {
    config_path    = var.kube_config
  }
}