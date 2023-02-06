resource "helm_release" "airflow" {
  name       = "airflow"
  namespace  = local.airflow_namespace
  repository = "https://airflow.apache.org"
  chart      = "airflow"
  version    = "1.7.0"
  timeout    = 600
  values     = local.overrides_file

  dynamic "set" {
    for_each = [for override in local.overrides : {
      name  = override.name
      value = override.value
    }]
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  depends_on = [
    docker_image.airflow
  ]
}
