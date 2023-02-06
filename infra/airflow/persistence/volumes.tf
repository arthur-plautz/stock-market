resource "kubernetes_persistent_volume_claim" "airflow_database" {
  metadata {
    name = "airflow-database-volume-claim"
    namespace = local.airflow_namespace
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.airflow_database.metadata.0.name}"
  }
}

resource "kubernetes_persistent_volume" "airflow_database" {
  metadata {
    name = "airflow-database-volume"
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      host_path {
        path = local.airflow_storage_path
        type = "Directory"
      }
    }
    storage_class_name = "standard"
  }
}