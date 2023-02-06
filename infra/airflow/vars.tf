locals {
  airflow_namespace      = "airflow"
  database_migration_job = true
  dags_path = "/src/airflow/dags"
  datalake_path = "/src/data"

  external_database_connection = "postgresql://postgres:${var.database_password}@airflow-database-postgresql:5432/airflow"

  image_name = "airflow-stock-market"
  image_version = "0.1"
  image_tag = "${local.image_name}:${local.image_version}"

  overrides_file = [file("./config/values_override.yml")]
  overrides = [
    {
      name = "images.airflow.repository",
      value = local.image_name
    },
    {
      name = "images.airflow.tag",
      value = local.image_version
    },
    {
      name  = "dags.persistence.existingClaim"
      value = kubernetes_persistent_volume_claim.dags.metadata.0.name
    },
    {
      name = "data.metadataSecretName"
      value = kubernetes_secret.airflow_database_connection.metadata.0.name
    },
    {
      name  = "scheduler.waitForMigrations.enabled"
      value = local.database_migration_job
    },
    {
      name  = "triggerer.waitForMigrations.enabled"
      value = local.database_migration_job
    },
    {
      name  = "webserver.waitForMigrations.enabled"
      value = local.database_migration_job
    },
    {
      name  = "migrateDatabaseJob.useHelmHooks"
      value = !local.database_migration_job
    },
    {
      name  = "migrateDatabaseJob.enabled"
      value = local.database_migration_job
    },
    {
      name  = "createUserJob.useHelmHooks"
      value = !local.database_migration_job
    }
  ]
}

variable database_password {
  type = string
  sensitive = true
  default = "airflow"
}

variable "docker_host" {
  type = string
}
variable "kube_config" {
  type = string
}