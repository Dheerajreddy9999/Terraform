terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 0.12"
  
}


# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}