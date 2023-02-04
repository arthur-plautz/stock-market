resource "docker_image" "airflow" {
  name = "airflow"

  build {
    context = "./docker"
    tag     = [local.image_tag]
  }
}