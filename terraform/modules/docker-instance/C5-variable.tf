# Secrets
variable "key_pair_name" {
  type = string
}
variable "private_key_file_name" {
  type = string
}
# variable "private_key_path" {
#   type = string
# }
# Network
variable "subnet_id" {
  type = string
}
variable "sg_id" {
  
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

# Instance
variable "instance_name" {
  type = string
}
variable "ami_id" {
  type = string
}
variable "instance_type" {
  type = string
  default = "t3.micro"
}
# Docker hub
variable "DOCKER_USERNAME" {
  type = string
}
variable "DOCKER_PASSWORD" {
  type = string
  sensitive = true
}
# Instance environment variables
# S3 Bucket
variable "s3_bucket_name" {
  type = string
}

# Tags
variable "env" {
  type = string
}

variable "files_to_copy" {
  type = list(object({
    source      = string
    destination = string
  }))
}

variable "monitor_instance_private_ip" {
  type = string
  default = null
}