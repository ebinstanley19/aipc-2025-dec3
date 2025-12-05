resource "docker_image" "database_image" {
  name = "chukmunnlee/bgg-database:nov-2025"
}

resource "docker_image" "application_image" {
  name = "chukmunnlee/bgg-app:nov-2025"
}

resource "docker_image" "nginx_image" {
  name = "nginx:latest"
}
