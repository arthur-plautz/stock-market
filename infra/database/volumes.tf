resource "kubernetes_persistent_volume_claim" "database" {
  metadata {
    name = "database-volume-claim"
    namespace = local.database_namespace
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.database.metadata.0.name}"
  }
}

resource "kubernetes_persistent_volume" "database" {
  metadata {
    name = "database-volume"
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      host_path {
        path = local.database_storage_path
        type = "Directory"
      }
    }
    storage_class_name = "standard"
  }
}