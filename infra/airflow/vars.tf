locals {
  airflow_namespace      = "airflow"
  database_migration_job = true
  dags_path = "/src/dags"

  overrides_file = [file("./config/values_override.yml")]
  overrides = [
    {
      name  = "dags.persistence.existingClaim"
      value = kubernetes_persistent_volume_claim.dags.metadata.0.name
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
