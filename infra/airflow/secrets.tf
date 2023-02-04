resource "kubernetes_secret" "airflow_environment" {
  metadata {
    name      = "airflow-environment-variables"
    namespace = local.airflow_namespace
  }

  data = {
    AIRFLOW__SCHEDULER__DAG_DIR_LIST_INTERVAL     = 60
    AIRFLOW__SCHEDULER__MIN_FILE_PROCESS_INTERVAL = 20
  }

  type = "kubernetes.io/opaque"
}
