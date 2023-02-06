resource "kubernetes_secret" "postgres_password" {
  metadata {
    name = "postgres-password"
    namespace = local.database_namespace
  }

  data = {
    password = var.database_password
  }
}