locals {
  airflow_namespace = "airflow"
  airflow_storage_path = "/src/data/airflow"
}

variable "airflow_database_password" {
    type = string
    default = "airflow"
    sensitive = true
}

variable "kube_config" {
    type = string
}