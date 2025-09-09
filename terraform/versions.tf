terraform {
  backend "s3" {
    bucket = "thuan-nguyen"
    region = "ap-southeast-1"
    encrypt = true
    key = "tf/terraform.tfstate"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.97.0"  
    }
  }
}