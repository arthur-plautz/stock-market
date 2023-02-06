resource "kubernetes_namespace" "database_namespace" {
  metadata {
    name = local.database_namespace
  }
}


resource "helm_release" "database" {
  name       = "database"
  namespace = local.database_namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "12.1.14"

  set {
    name  = "global.postgresql.auth.existingSecret"
    value = "postgres-password"
  }
  set {
    name = "global.postgresql.auth.secretKeys.adminPasswordKey"
    value = "password"
  }
  set {
    name = "primary.persistence.existingClaim"
    value = kubernetes_persistent_volume_claim.database.metadata.0.name
  }

  values = local.overrides_file
}
