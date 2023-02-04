resource "kubernetes_secret" "postgres_password" {
  metadata {
    name = "postgres-password"
  }

  data = {
    password = var.database_password
  }
}

resource "helm_release" "database" {
  name       = "database"
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
}
