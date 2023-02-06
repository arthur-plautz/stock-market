resource "kubernetes_secret" "airflow_database_password" {
  metadata {
    name = "airflow-database-password"
    namespace = local.airflow_namespace
  }

  data = {
    password = var.airflow_database_password
  }
}