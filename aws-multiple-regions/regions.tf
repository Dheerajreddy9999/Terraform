terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 0.12"
  
}

provider "aws" {
    alias = "us-east-2"
    region = "us-east-2"
}


provider "aws" {
    alias = "us-west-1"
    region = "us-west-1"
}

resource "aws_instance" "example1" {
  ami = "ami-024e6efaf93d85776"
  instance_type = "t2.micro"
  provider = "aws.us-east-2"
}

resource "aws_instance" "example12" {
  ami = "ami-0f8e81a3da6e2510a"
  instance_type = "t2.micro"
  provider = "aws.us-west-1"
}
