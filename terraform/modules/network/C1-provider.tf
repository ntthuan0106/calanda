terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.97.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.1.0"
    }
  }
}