terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#This Configure the AWS Provider
provider "aws" {
 region = ""
 access_key = ""
 secret_key = ""
}




