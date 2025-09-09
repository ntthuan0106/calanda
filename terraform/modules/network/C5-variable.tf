# Network
variable "region" {
  type = string
}
variable "vpc_name" {
  type = string
}
variable "vpc_cidr_block" {
  type = string
  default = "172.16.0.0/16"
}
variable "associate_public_ip_address" {
  type = bool
  default = true
}
variable "map_public_ip_on_launch" {
  type = bool
  default = true
}
variable "subnet_az" {
  type = string
  default = "ap-southeast-1a"
}
# Tags
variable "env" {
  type = string
}
