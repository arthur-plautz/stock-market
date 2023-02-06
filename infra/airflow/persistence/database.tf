resource "kubernetes_namespace" "airflow_namespace" {
  metadata {
    name = local.airflow_namespace
  }
}

resource "helm_release" "database" {
  name       = "airflow-database"
  namespace = local.airflow_namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "12.1.14"

  set {
    name  = "global.postgresql.auth.existingSecret"
    value = "airflow-database-password"
  }
  set {
    name = "global.postgresql.auth.secretKeys.adminPasswordKey"
    value = "password"
  }
  set {
    name = "primary.persistence.existingClaim"
    value = kubernetes_persistent_volume_claim.airflow_database.metadata.0.name
  }
  set {
    name = "auth.database"
    value = "airflow"
  }
}
