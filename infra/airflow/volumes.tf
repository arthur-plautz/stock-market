resource "kubernetes_persistent_volume_claim" "dags" {
  metadata {
    name = "airflow-dags-volume-claim"
    namespace = local.airflow_namespace
  }
  spec {
    access_modes = ["ReadOnlyMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.dags.metadata.0.name}"
  }
}

resource "kubernetes_persistent_volume" "dags" {
  metadata {
    name = "airflow-dags-volume"
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadOnlyMany"]
    persistent_volume_source {
      host_path {
        path = local.dags_path
        type = "Directory"
      }
    }
    storage_class_name = "standard"
  }
}