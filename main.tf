terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 0.12"
  
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}



resource "aws_instance" "web" {
  ami           = "ami-024e6efaf93d85776"
  instance_type = "t2.micro"

  tags = {
    Name = "web-servers"
    app = "jenkins"
  }
}

