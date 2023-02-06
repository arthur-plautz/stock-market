locals {
  database_namespace = "database"
  database_storage_path = "/src/data/database"

  overrides_file = [file("config/values_override.yml")]
}

variable "database_password" {
    type = string
    sensitive = true
    default = "database"
}

variable "kube_config" {
    type = string
}