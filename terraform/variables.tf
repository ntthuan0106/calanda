variable "DOCKER_USERNAME" {
  type = string
}
variable "DOCKER_PASSWORD" {
  type = string
  sensitive = true
}